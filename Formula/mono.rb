class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https://www.mono-project.com/"
  url "https://download.mono-project.com/sources/mono/mono-6.12.0.107.tar.xz"
  sha256 "61f3cd629f8e99371c6b47c1f8d96b8ac46d9e851b5531eef20cdf9ab60d2a5f"
  license "MIT"

  livecheck do
    url "https://www.mono-project.com/download/stable/"
    regex(/href=.*?(\d+(?:\.\d+)+)[._-]macos/i)
  end

  bottle do
    sha256 big_sur:  "cc88ee58cc672b0eed70bff3fc8cd7bdc7ea219f0c95e1129193b188edff34dc"
    sha256 catalina: "5180d906bcffc14c55bb32298b6bae70f3f0aec49777f92f8926ec2fc80d2d10"
    sha256 mojave:   "a32daf667d9507ede278e478d4060a7fff234d3720e1382819310c0903626a2a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9"

  uses_from_macos "unzip" => :build

  conflicts_with "xsd", because: "both install `xsd` binaries"
  conflicts_with cask: "mono-mdk"
  conflicts_with cask: "mono-mdk-for-visual-studio"

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
    url "https://github.com/dotnet/fsharp.git",
        tag:      "v11.0.0-beta.20471.5",
        revision: "03283e07f6bd5717797acb288cf6044cedca2202"
    # F# patches hhen upgrading Mono, make sure to use the revision from
    # https://github.com/mono/mono/blob/mono-#{version}/packaging/MacSDK/fsharp.py
    patch do
      url "https://raw.githubusercontent.com/mono/mono/a22ed3f094e18f1f82e1c6cead28d872d3c57e40/packaging/MacSDK/patches/fsharp-portable-pdb.patch"
      sha256 "5b09b0c18b7815311680cc3ecd9bb30d92a307f3f2103a5b58b06bc3a0613ed4"
    end
    patch do
      url "https://raw.githubusercontent.com/mono/mono/a22ed3f094e18f1f82e1c6cead28d872d3c57e40/packaging/MacSDK/patches/fsharp-netfx-multitarget.patch"
      sha256 "112f885d4833effb442cf586492cdbd7401d6c2ba9d8078fe55e896cc82624d7"
    end
    patch do
      url "https://github.com/dotnet/fsharp/commit/be6b22d11ae996b2d9b8e0724d9cf05ad65a0485.patch?full_index=1"
      sha256 "793a39da798673b99289f3ac344ff8bd23d7eea2d3366c28e7e42229d8b130ca"
    end
  end

  resource "fsharp-layout-patch" do
    url "https://raw.githubusercontent.com/mono/mono/3070886a1c5e3e3026d1077e36e67bd5310e0faa/packaging/MacSDK/fsharp-layout.sh"
    sha256 "f2cc63bf77e50663d91c6d102ba1d9217d1b9100c57071f79f0ae5a45e80ef42"
  end

  # When upgrading Mono, make sure to use the revision from
  # https://github.com/mono/mono/blob/mono-#{version}/packaging/MacSDK/msbuild.py
  resource "msbuild" do
    url "https://github.com/mono/msbuild.git",
        revision: "db750f72af92181ec860b5150b40140583972c22"

    # Remove in next release
    # https://github.com/dotnet/msbuild/issues/6041
    # https://github.com/dotnet/msbuild/pull/5381
    patch do
      url "https://github.com/mono/msbuild/commit/e2e4dfee543269ccb0a459263985b1c993feacec.patch?full_index=1"
      sha256 "b64e93fbe1f5a5b8bcdb46ddd7d51a714f0e671b1b8ce2d1c2a0b80710ecb293"
    end
    patch do
      url "https://github.com/mono/msbuild/commit/509c3190cf77be9422bddfad30b89e158f6229c3.patch?full_index=1"
      sha256 "cf5fc342319cc1cb3b7bff02ec7d7d69af07f2777cf5b1910274d757cb14d92a"
    end
    patch do
      url "https://github.com/mono/msbuild/commit/70bf6710473a2b6ffe363ea588f7b3ab87682a8d.patch?full_index=1"
      sha256 "630b4187e882c162cd09e14f16ef2cca29b588dbea71bc444d925e5ef3f8f067"
    end
  end

  # Temporary patch remove in the next mono release
  patch do
    url "https://github.com/mono/mono/commit/3070886a1c5e3e3026d1077e36e67bd5310e0faa.patch?full_index=1"
    sha256 "b415d632ced09649f1a3c1b93ffce097f7c57dac843f16ec0c70dd93c9f64d52"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--enable-nls=no"
    system "make"
    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin/"mono-gdb.py", bin/"mono-sgen-gdb.py"

    # We'll need mono for msbuild, and then later msbuild for fsharp
    ENV.prepend_path "PATH", bin

    # Next build msbuild
    resource("msbuild").stage do
      system "./eng/cibuild_bootstrapped_msbuild.sh", "--host_type", "mono",
             "--configuration", "Release", "--skip_tests"

      system "./stage1/mono-msbuild/msbuild", "mono/build/install.proj",
             "/p:MonoInstallPrefix=#{prefix}", "/p:Configuration=Release-MONO",
             "/p:IgnoreDiffFailure=true"
    end

    # Finally build and install fsharp as well
    resource("fsharp").stage do
      # Temporary fix for use propper .NET SDK remove in next release
      inreplace "./global.json", "3.1.302", "3.1.405"
      system "./build.sh", "-c", "Release"
      ENV["version"]=""
      system "./.dotnet/dotnet", "restore", "setup/Swix/Microsoft.FSharp.SDK/Microsoft.FSharp.SDK.csproj",
        "--packages", "fsharp-nugets"
      system "bash", "#{buildpath}/packaging/MacSDK/fsharp-layout.sh", ".", prefix
    end
  end

  def caveats
    <<~EOS
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
    system bin/"msbuild", "test.csproj"

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
          <TargetFrameworkVersion>v4.7.2</TargetFrameworkVersion>
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
    system bin/"msbuild", "test.fsproj"
  end
end
