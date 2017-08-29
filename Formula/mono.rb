class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "http://www.mono-project.com/"
  url "https://download.mono-project.com/sources/mono/mono-5.2.0.215.tar.bz2"
  sha256 "8f0cebd3f7b03f68b9bd015706da9c713ed968004612f1ef8350993d8fe850ea"

  bottle do
    sha256 "8dab2660d98e8e3bb1fa7f4640db04ef33e4e7fcfb7c3ef8a5c718e5254d80bd" => :sierra
    sha256 "89d4d7f5df7bbf0e61a24e042bac29c41433dd71e8008394ce181ef6e7a4b77f" => :el_capitan
    sha256 "72dd883ab2c394bde73325086350545db1a0a0414989fb28b9a31b7b8217c7a7" => :yosemite
  end

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  link_overwrite "bin/fsharpi"
  link_overwrite "bin/fsharpiAnyCpu"
  link_overwrite "bin/fsharpc"
  link_overwrite "bin/fssrgen"
  link_overwrite "bin/msbuild"
  link_overwrite "lib/mono"
  link_overwrite "lib/cli"

  option "without-fsharp", "Build without support for the F# language."
  option "without-msbuild", "Build without support for the MSBuild."

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "openssl" => :build

  conflicts_with "xsd", :because => "both install `xsd` binaries"

  resource "fsharp" do
    url "https://github.com/fsharp/fsharp.git",
        :tag => "4.1.25",
        :revision => "9687f27c3e6be7b9e1646bb9ee1ae0b02080daae"
  end

  resource "msbuild" do
    url "https://@github.com/mono/msbuild.git",
        :revision => "17f02c2719a2c503f2955f8b15d00cc7db90ab2a"
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

    # Now build and install msbuild as well
    if build.with? "msbuild"
      resource("msbuild").stage do
        ENV.prepend_path "PATH", bin
        inreplace "init-tools.sh", "$__DOTNET_CMD restore \"",
                    "  DYLD_LIBRARY_PATH=#{Formula["openssl"].opt_prefix}/lib $__DOTNET_CMD restore \""
        inreplace "init-tools.sh", "    $__BUILD_TOOLS_PATH/init-tools.sh",
                    "    sed -i '.origin' 's|^$__DOTNET_CMD |DYLD_LIBRARY_PATH=#{Formula["openssl"].opt_prefix}/lib $__DOTNET_CMD |g' $__BUILD_TOOLS_PATH/init-tools.sh\n    $__BUILD_TOOLS_PATH/init-tools.sh"
        inreplace "init-tools.sh", "    $__BUILD_TOOLS_PATH/init-tools.sh",
                    "    sed -i '.origin' $'s|# Temporary Hacks to fix couple of issues in the msbuild and roslyn nuget packages" \
                    "|mv $__DOTNET_CMD \"${__DOTNET_CMD}.exe\"<NEWLINE>necho \"#!/usr/bin/env bash\" >> $__DOTNET_CMD<NEWLINE>n" \
                    "echo \"DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib ${__DOTNET_CMD}.exe \\\\\\\\\\$@\" >> \"$__DOTNET_CMD\"<NEWLINE>n" \
                    "chmod +x \"$__DOTNET_CMD\"<NEWLINE>n# Temporary Hacks to fix couple of issues in the msbuild and roslyn nuget packages|g'" \
                    " $__BUILD_TOOLS_PATH/init-tools.sh\n    $__BUILD_TOOLS_PATH/init-tools.sh"
        inreplace "init-tools.sh", "<NEWLINE>", "\\\\\\\\\\\\"
        system "./cibuild.sh", "--scope", "Compile", "--host", "Mono", "--target", "Mono", "--config", "Release"
        mkpath "#{lib}/mono/msbuild/15.0/bin"
        cp_r "bin/Release-MONO/AnyCPU/OSX/OSX_Deployment/.", "#{lib}/mono/msbuild/15.0/bin"
        rm_r Dir["#{lib}/mono/msbuild/15.0/bin/*UnitTests*"]
        rm_r Dir["#{lib}/mono/msbuild/15.0/bin/*xunit*"]
        open("#{bin}/msbuild", "w+") do |f|
          f << "#!/bin/sh\n"
          f << "MONO_GC_PARAMS=\"nursery-size=64m,$MONO_GC_PARAMS\" exec #{bin}/mono $MONO_OPTIONS #{lib}/mono/msbuild/15.0/bin/MSBuild.dll \"$@\"\n"
        end
        chmod "a=rwx", "#{bin}/msbuild"
      end
    end

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
    Note that the 'mono' formula now includes F# and msbuild. If you have
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
    shell_output("#{bin}/mcs #{test_name}")
    output = shell_output("#{bin}/mono hello.exe")
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
    system bin/"xbuild", "test.csproj"
    system bin/"msbuild", "/version"

    if build.with? "fsharp"
      # Test that fsharpi is working
      ENV.prepend_path "PATH", bin
      (testpath/"test.fsx").write <<-EOS.undent
        printfn "#{test_str}"; 0
      EOS
      output = pipe_output("#{bin}/fsharpi test.fsx")
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
      system bin/"xbuild", "test.fsproj"
    end
  end
end
