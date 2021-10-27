class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https://www.mono-project.com/"
  url "https://download.mono-project.com/sources/mono/mono-6.12.0.122.tar.xz"
  sha256 "29c277660fc5e7513107aee1cbf8c5057c9370a4cdfeda2fc781be6986d89d23"
  license "MIT"

  livecheck do
    url "https://www.mono-project.com/download/stable/"
    regex(/href=.*?(\d+(?:\.\d+)+)[._-]macos/i)
  end

  bottle do
    sha256 monterey: "4a4560ef7bd6dc638600e6fae876c3e27b3443698719a1dae45fe49fc1987f78"
    sha256 big_sur:  "fdd17b0e0eb154047fa8091b52763f1f0df0fc921c216f6633d4d59f7cd62af5"
    sha256 catalina: "428998efcf415948ca793b166d7ed6e242814205238e77111419de828fd33cfe"
    sha256 mojave:   "d25b6982b6bd7af6b001e5f7b53ff0dad68937ce11ba0dce9d1529e2b0608b85"
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
        revision: "70bf6710473a2b6ffe363ea588f7b3ab87682a8d"
  end

  # Remove use of -flat_namespace. Upstreamed at
  # https://github.com/mono/mono/pull/21257
  patch :DATA

  # Temporary patch remove in the next mono release
  patch do
    url "https://github.com/mono/mono/commit/3070886a1c5e3e3026d1077e36e67bd5310e0faa.patch?full_index=1"
    sha256 "b415d632ced09649f1a3c1b93ffce097f7c57dac843f16ec0c70dd93c9f64d52"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
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

__END__
diff --git a/mono/profiler/Makefile.in b/mono/profiler/Makefile.in
index 48bcfad..58273a5 100644
--- a/mono/profiler/Makefile.in
+++ b/mono/profiler/Makefile.in
@@ -647,7 +647,7 @@ glib_libs = $(top_builddir)/mono/eglib/libeglib.la
 #
 # See: https://bugzilla.xamarin.com/show_bug.cgi?id=57011
 @DISABLE_LIBRARIES_FALSE@@DISABLE_PROFILER_FALSE@@ENABLE_COOP_SUSPEND_FALSE@@HOST_WIN32_FALSE@check_targets = run-test
-@BITCODE_FALSE@@HOST_DARWIN_TRUE@prof_ldflags = -Wl,-undefined -Wl,suppress -Wl,-flat_namespace
+@BITCODE_FALSE@@HOST_DARWIN_TRUE@prof_ldflags = -Wl,-undefined -Wl,dynamic_lookup
 
 # On Apple hosts, we want to allow undefined symbols when building the
 # profiler modules as, just like on Linux, we don't link them to libmono,
