class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "http://www.mono-project.com/"
  url "https://download.mono-project.com/sources/mono/mono-4.4.2.11.tar.bz2"
  sha256 "900c2cc25ee55adeec04e1ae889316efc127c82cc0c392f928421f19f8f5b633"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  bottle do
    sha256 "a66f5ee144eb47657f56a417e8ddea9ffa496b92dea648fc9fb7771d8478d41d" => :el_capitan
    sha256 "02c559d621cbffe9651f99be5c36ffb799d527992f9de59f8089c67721e1086d" => :yosemite
    sha256 "e89db5505a780fe358af7c160b571dd0b32ef8d72e099589ff29bdfa41fef29f" => :mavericks
  end

  conflicts_with "czmq", :because => "both install `makecert` binaries"

  option "without-fsharp", "Build without support for the F# language."

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  resource "fsharp" do
    url "https://github.com/fsharp/fsharp.git", :tag => "4.0.1.10",
                                                :revision => "d654e56bbc09bd6c1da5bd1f07abc1d9d347b6c3"
  end

  link_overwrite "bin/fsharpi"
  link_overwrite "bin/fsharpiAnyCpu"
  link_overwrite "bin/fsharpc"
  link_overwrite "bin/fssrgen"
  link_overwrite "lib/mono"
  link_overwrite "lib/cli"

  conflicts_with "xsd", :because => "both install `xsd` binaries"

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
  end

  def caveats; <<-EOS.undent
    To use the assemblies from other formulae you need to set:
      export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    Note that the 'mono' formula now includes F#. If you have
    the 'fsharp' formula installed, remove it with 'brew uninstall fsharp'.
    EOS
  end

  test do
    test_str = "Hello Homebrew"
    test_name = "hello.cs"
    (testpath/test_name).write <<-EOS.undent
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    EOS
    shell_output "#{bin}/mcs #{test_name}"
    output = shell_output "#{bin}/mono hello.exe"
    assert_match test_str, output.strip

    # Tests that xbuild is able to execute lib/mono/*/mcs.exe
    (testpath/"test.csproj").write <<-EOS.undent
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
    system "#{bin}/xbuild", "test.csproj"

    if build.with? "fsharp"
      # Test that fsharpi is working
      ENV.prepend_path "PATH", bin
      output = pipe_output("#{bin}/fsharpi", "printfn \"#{test_str}\"; exit 0")
      assert_match test_str, output

      # Tests that xbuild is able to execute fsc.exe
      (testpath/"test.fsproj").write <<-EOS.undent
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
      (testpath/"Main.fs").write <<-EOS.undent
        [<EntryPoint>]
        let main _ = printfn "#{test_str}"; 0
      EOS
      system "#{bin}/xbuild", "test.fsproj"
    end
  end
end
