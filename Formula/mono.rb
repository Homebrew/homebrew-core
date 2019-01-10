class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https://www.mono-project.com/"
  url "https://download.mono-project.com/sources/mono/mono-5.18.0.225.tar.bz2"
  sha256 "91aa3e8a12aaf94760a092866abc5c5f1f437ecd0a97bedfff857c439aa7a87f"

  bottle do
    rebuild 1
    sha256 "9eafd6e0b93f4c2b93b1ea57c42f3282f052db3ac712f31465564ba76faea936" => :mojave
    sha256 "e0b8d7a241aba9e236af9626006cf8a8c0a7c7a0eaeb764e5d7e28d4da4d82e8" => :high_sierra
    sha256 "3e09a75b4dac30fc56cec97e3127b3c047f7613fd259f68c08444806cf7e8e7a" => :sierra
  end

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
    resource("fsharp").stage do
      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      system "make"
      system "make", "install"
    end
  end

  def caveats; <<~EOS
    To use the assemblies from other formulae you need to set:
      export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
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
