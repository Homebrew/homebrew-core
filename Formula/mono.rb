class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "http://www.mono-project.com/"
  url "https://download.mono-project.com/sources/mono/mono-5.4.1.6.tar.bz2"
  sha256 "bdfda0fe9ad5ce20bb2cf9e9bf28fed40f324141297479824e1f65d97da565df"

  bottle do
    sha256 "4180790335196a33a716ddb0bb1b6ba6a3487babedd8baac6de2458aff038906" => :high_sierra
    sha256 "8ae5763ad3b6e84ac078ca83f729fe47e5f8d048a87ab0a5892c2b22b4c5854a" => :sierra
    sha256 "8476cab8863aabdd7c64bff4a31b57aed56192baa71383b8f3ffcc8f41a45fb5" => :el_capitan
  end

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  link_overwrite "bin/fsharpi"
  link_overwrite "bin/fsharpiAnyCpu"
  link_overwrite "bin/fsharpc"
  link_overwrite "bin/fssrgen"
  link_overwrite "lib/mono"
  link_overwrite "lib/cli"

  option "without-fsharp", "Build without support for the F# language."
  option "without-msbuild", "Build without msbuild (xbuild is still installed)."

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build

  depends_on "openssl" => :build if build.with? "msbuild"

  # this is probably not necessary if OSX < high sierra.
  depends_on "curl" => :build if build.with? "msbuild"

  conflicts_with "xsd", :because => "both install `xsd` binaries"

  resource "fsharp" do
    url "https://github.com/fsharp/fsharp.git",
        :tag => "4.1.23",
        :revision => "35a4a5b1f26927259c3213465a47b27ffcd5cb4d"
  end

  resource "msbuild" do
    url "https://github.com/mono/msbuild.git",
        :branch => "mono-2017-06",
        :revision => "f296e67b6004dd39c3f43b177bcf45dfbe931341"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-nls=no
    ]

    args << "--build=" + (MacOS.prefer_64_bit? ? "x86_64": "i686") + "-apple-darwin"

    system "./configure", *args
    system "make"
    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin/"mono-gdb.py", bin/"mono-sgen-gdb.py"

    # Now build and install fsharp as well
    if build.with? "fsharp"
      resource("fsharp").stage do
        ENV.prepend_path "PATH", bin
        ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
        system "./autogen.sh", "--prefix=#{prefix}"
        system "make"
        system "make", "install"
      end
    end

    if build.with? "msbuild"
      resource("msbuild").stage do
        ENV.prepend_path "PATH", bin
        msbpath = Pathname.getwd

        # MSBuild's bootstrapper uses the dotnet cli, which in turn uses both
        # OpenSSL and libcurl. We use homebrew formulas for those libraries and
        # ensure the bootstrapped dotnet client does use homebrew's openssl+libcurl.

        # Due to OSX SIP, we need to set up a wrapper to the dotnet client.
        # Setting environment library search path variables won't work.
        # (https://developer.apple.com/library/content/documentation/Security/Conceptual/System_Integrity_Protection_Guide/RuntimeProtections/RuntimeProtections.html)

        # Build DYLD_LIBRARY_PATH with openssl and curl keg paths
        ldlibpath = Formula["openssl"].opt_prefix.to_s + "/lib"
        ldlibpath << ":" + Formula["curl"].opt_prefix.to_s + "/lib"

        if ENV["DYLD_LIBRARY_PATH"].nil?
          # there seems to be no way to get the default search path from OS X,
          # they are hardcoded within dyld.cpp and not in environment variables
          # by default
          ldlibpath << ":/usr/lib:/usr/local/lib"
        else
          # In case the environment variable defined, just prepend our paths
          # The kegs must precede other paths so they are chosen first.
          ldlibpath << ":" + ENV["DYLD_LIBRARY_PATH"]
        end

        # Draw the wrapper to call dotnet CLI using the brew library paths
        (msbpath/"dotnetcli_wrapper.sh").write <<~EOS
          #!/usr/bin/env bash
          DYLD_LIBRARY_PATH='#{ldlibpath}' \"\$(dirname \${BASH_SOURCE[0]})\"/dotnet_org \"\${@}\"
        EOS
        File.chmod(0755, "dotnetcli_wrapper.sh")

        # Now this script will replace the dotnet cli by the wrapper
        (msbpath/"wrap_dotnetcli.sh").write <<~EOS
          #!/usr/bin/env bash
          echo -n "Wrapping the dotnet client tool to use homebrew libraries: "
          mv Tools/dotnetcli/dotnet Tools/dotnetcli/dotnet_org
          mv dotnetcli_wrapper.sh Tools/dotnetcli/dotnet
          echo "done."
        EOS
        File.chmod(0755, "wrap_dotnetcli.sh")

        # Tamper into the build script so that it wraps the dotnet client as
        # soon as it becomes available
        init_script = "./init-tools.sh"
        data = File.readlines(init_script)

        File.open(init_script, "w") do |script_handle|
          data.each do |line|
            script_handle.write(line)
            unless line.match(/^ +cd \$__scriptpath$/).nil?
              script_handle.write("./wrap_dotnetcli.sh\n")
            end
          end
        end

        system "make", "all-mono"

        system "./install-mono-prefix.sh", prefix.to_s
      end
    end
  end

  def caveats; <<~EOS
    To use the assemblies from other formulae you need to set:
      export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    Note that the 'mono' formula now includes F#. If you have
    the 'fsharp' formula installed, remove it with 'brew uninstall fsharp'.
    EOS
  end

  test do
    test_str = "Hello Homebrew"
    test_name = "hello.cs"
    (testpath/test_name).write <<~EOS
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    EOS
    shell_output("#{bin}/mcs #{test_name}")
    output = shell_output("#{bin}/mono hello.exe")
    assert_match test_str, output.strip

    # Tests that xbuild is able to execute lib/mono/*/mcs.exe
    (testpath/"test.csproj").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <Project ToolsVersion="4.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
        <PropertyGroup>
          <AssemblyName>HomebrewMonoTest</AssemblyName>
          <TargetFrameworkVersion>v4.5</TargetFrameworkVersion>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="#{test_name}" />
        </ItemGroup>
        <Import Project="$(MSBuildBinPath)\\Microsoft.CSharp.targets" />
      </Project>
    EOS
    system bin/"xbuild", "test.csproj"

    if build.with? "fsharp"
      # Test that fsharpi is working
      ENV.prepend_path "PATH", bin
      (testpath/"test.fsx").write <<~EOS
        printfn "#{test_str}"; 0
      EOS
      output = pipe_output("#{bin}/fsharpi test.fsx")
      assert_match test_str, output

      # Tests that xbuild is able to execute fsc.exe
      (testpath/"test.fsproj").write <<~EOS
        <?xml version="1.0" encoding="utf-8"?>
        <Project ToolsVersion="4.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
          <PropertyGroup>
            <ProductVersion>8.0.30703</ProductVersion>
            <SchemaVersion>2.0</SchemaVersion>
            <ProjectGuid>{B6AB4EF3-8F60-41A1-AB0C-851A6DEB169E}</ProjectGuid>
            <OutputType>Exe</OutputType>
            <FSharpTargetsPath>$(MSBuildExtensionsPath32)\\Microsoft\\VisualStudio\\v$(VisualStudioVersion)\\FSharp\\Microsoft.FSharp.Targets</FSharpTargetsPath>
          </PropertyGroup>
          <Import Project="$(FSharpTargetsPath)" Condition="Exists('$(FSharpTargetsPath)')" />
          <ItemGroup>
            <Compile Include="Main.fs" />
          </ItemGroup>
          <ItemGroup>
            <Reference Include="mscorlib" />
            <Reference Include="System" />
            <Reference Include="FSharp.Core" />
          </ItemGroup>
        </Project>
      EOS
      (testpath/"Main.fs").write <<~EOS
        [<EntryPoint>]
        let main _ = printfn "#{test_str}"; 0
      EOS
      system bin/"xbuild", "test.fsproj"
    end

    if build.with? "msbuild"
      # Just rebuild the main project with msbuild
      pjpath = (testpath/"msbld")
      Dir.mkdir(pjpath)
      (pjpath/test_name).write((testpath/test_name).read)
      (pjpath/"test.csproj").write((testpath/"test.csproj").read)
      pjpath.cd do
        system bin/"msbuild", "test.csproj"

        output = shell_output("#{bin}/mono bin/Debug/HomebrewMonoTest.exe")
        assert_match test_str, output.strip
      end
    end
  end
end
