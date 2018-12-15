class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https://www.mono-project.com/"
  url "https://download.mono-project.com/sources/mono/mono-5.16.0.220.tar.bz2"
  sha256 "f420867232b426c062fa182256a66b29efa92992c119847359cdd1ab75af8de3"

  bottle do
    sha256 "f31bcdbf40da4f3160c6257e62532e82fda34f00e8170424d85b3737cc166c74" => :mojave
    sha256 "32a208795022a8aa55c86c4f77aca63725d9fe957998c160e43b9048898ce2fa" => :high_sierra
    sha256 "5b881b5ed9b9fdcef2003dc6f525887f27df2278349644dc8ba446ea4a1b62e5" => :sierra
    sha256 "22551363ddcd90271af6bac89055ea7bfdf0647455b9ea0be355649dfc6e6e9a" => :el_capitan
  end

  option "without-fsharp", "Build without support for the F# language."

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  conflicts_with "xsd", :because => "both install `xsd` binaries"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  link_overwrite "bin/fsharpi"
  link_overwrite "bin/fsharpiAnyCpu"
  link_overwrite "bin/fsharpc"
  link_overwrite "bin/fssrgen"
  link_overwrite "lib/mono"
  link_overwrite "lib/cli"

  resource "fsharp" do
    url "https://github.com/fsharp/fsharp.git",
        :tag      => "10.2.1",
        :revision => "3de387432de8d11a89f99d1af87aa9ce194fe21b"
  end

  # When upgrading Mono, make sure to use the revision from
  # https://github.com/mono/mono/blob/mono-#{version}/packaging/MacSDK/msbuild.py
  resource "msbuild" do
    url "https://github.com/mono/msbuild.git",
        :revision => "e6c3a1f9e4d3ee4b88ef7bd98b7a48a998c199e6"
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

    # We'll need mono for msbuild, and then later msbuild for fsharp
    ENV.prepend_path "PATH", bin

    # Next build msbuild
    resource("msbuild").stage do
      system "./build.sh", "-hostType", "mono", "-configuration", "Release", "-skipTests"
      system "./artifacts/mono-msbuild/msbuild", "mono/build/install.proj",
             "/p:MonoInstallPrefix=#{prefix}", "/p:Configuration=Release-MONO",
             "/p:IgnoreDiffFailure=true"
    end

    # Finally build and install fsharp as well
    if build.with? "fsharp"
      resource("fsharp").stage do
        ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
        system "make"
        system "make", "install"
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
  end
end
