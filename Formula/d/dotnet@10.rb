class DotnetAT10 < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  # Source-build tag announced at https://github.com/dotnet/source-build/discussions
  url "https://github.com/dotnet/dotnet/releases/download/v10.0.404/release.json"
  sha256 "c105fc81677985c6c845a74b8986e7388354a275579c188ec529eabfa7389363"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://builds.dotnet.microsoft.com/dotnet/release-metadata/10.0/releases.json"
    strategy :json do |json|
      json["latest-sdk"]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3b820aad1ba0859db5ab9b5cba4678f7eacc92862715c6c89a537e556dc83e4f"
    sha256 cellar: :any, arm64_tahoe:       "a0846d2bd5c5577b3bb8c58e4b9b8a21a5ce96f0dad568c54e178faa5482ed2b"
    sha256 cellar: :any, arm64_sequoia:     "157118d4c8d95d6cdd7552309e17dad712b2ceaeda8e6b5db053b7d8df4b1294"
    sha256 cellar: :any, arm64_linux:       "8f509716a7b697be5ce25b6012ff6367e64e87b7bbfe605c4f8c10ddb008099b"
    sha256 cellar: :any, x86_64_linux:      "3eb4b72e4e4984063ba55c0b50995de2580c3dab4fcee698972e959175aa2492"
  end

  keg_only :versioned_formula

  # https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core#lifecycle
  deprecate! date: "2028-11-14", because: :unsupported
  disable! date: "2029-11-14", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "brotli"
  depends_on "icu4c@79"
  depends_on "openssl@4"

  uses_from_macos "cpio" => :build
  uses_from_macos "python" => :build
  uses_from_macos "krb5"

  on_macos do
    depends_on "bash" => :build
    depends_on "grep" => :build # grep: invalid option -- P
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
    depends_on "zlib-ng-compat"

    on_intel do
      depends_on "llvm" => :build

      fails_with :gcc do
        cause "Illegal instruction when running crossgen2"
      end
    end
  end

  resource "src" do
    url "https://github.com/dotnet/dotnet/archive/refs/tags/v10.0.404.tar.gz"
    sha256 "e525145b764b2f0b19a1ab868482cc3e6334bbfc7c87837cfe077a106ad53224"

    livecheck do
      formula :parent
    end
  end

  resource "1xx" do
    url "https://github.com/dotnet/dotnet/archive/refs/tags/v10.0.115.tar.gz"
    sha256 "e3e4ece63a40c7e7c67ebf76ec342c4ef706bf43b1d5b9e320d3514782439be9"

    livecheck do
      url "https://builds.dotnet.microsoft.com/dotnet/release-metadata/10.0/releases.json"
      regex(/^v?(10\.0\.1\d\d)$/i)
      strategy :json do |json, regex|
        latest_release = json["releases"]&.find { |release| release["release-version"] == json["latest-release"] }
        next if latest_release.blank?

        latest_release["sdks"]&.filter_map do |sdk|
          sdk["version"]&.[](regex, 1)
        end
      end
    end

    # Avoid OpenSSL APIs missing from the shim with OpenSSL 4.1
    patch do
      file "Patches/dotnet/openssl-4.1-ocsp-bio.patch"
      directory "src/runtime"
      type :backport
      resolves "https://github.com/dotnet/runtime/pull/136435"
    end
  end

  resource "1xx-manifest" do
    url "https://github.com/dotnet/dotnet/releases/download/v10.0.115/release.json"
    sha256 "a73ff8d9c1ebdd96e6999f7a90b3db2e2e3a35ba4ed7e42a6ad890e85c6899d8"

    livecheck do
      url "https://builds.dotnet.microsoft.com/dotnet/release-metadata/10.0/releases.json"
      regex(/^v?(10\.0\.1\d\d)$/i)
      strategy :json do |json, regex|
        latest_release = json["releases"]&.find { |release| release["release-version"] == json["latest-release"] }
        next if latest_release.blank?

        latest_release["sdks"]&.filter_map do |sdk|
          sdk["version"]&.[](regex, 1)
        end
      end
    end
  end

  resource "docfx", :test do
    url "https://github.com/dotnet/docfx/archive/refs/tags/v2.81.0.tar.gz"
    sha256 "55b492cab70a7f883ea5e9a7a134a23d25d70e97153b61d1083ad6b5fa6e2d68"

    livecheck do
      url "https://formulae.brew.sh/api/formula/docfx.json"
      strategy :json do |json|
        json.dig("versions", "stable")
      end
    end
  end

  # Perform "1xx" or "2xx/3xx/4xx" Band Bootstrap. Skipping stage 2 as didn't work via documented steps
  # https://github.com/dotnet/source-build/blob/main/Documentation/feature-band-source-building.md
  def bootstrap_build(with_shared_components: nil)
    args = %w[
      --clean-while-building
      --release-manifest release.json
      --source-only
      --with-system-libs all
    ]
    args += ["--with-shared-components", with_shared_components] if with_shared_components
    on_linux do
      args << "-p:PortableBuild=true"
    end

    # FIXME: Workaround for brew sandbox. Consider allowing '/tmp/MSBuild\d+'
    on_macos do
      inreplace Dir["src/msbuild/src/{Shared,Framework/BackEnd}/NamedPipeUtil.cs"],
                'Path.Combine("/tmp", pipeName)',
                'Path.Combine(Path.GetTempPath().Length < 38 ? Path.GetTempPath() : "/tmp", pipeName)'
      # `prep-source-build.sh` runs binary detection with the prebuilt SDK, so patch its MSBuild first
      system "./prep-source-build.sh", "--no-binary-removal"
      # Avoid worker nodes, which the unpatched bootstrap MSBuild cannot reach
      system ".dotnet/dotnet", "build", "src/msbuild/src/MSBuild/MSBuild.csproj", "--configuration", "Release",
             "-maxcpucount:1"
      # Replace the bootstrap SDK's MSBuild with the patched one
      cp Dir["src/msbuild/artifacts/bin/MSBuild/Release/net*/{MSBuild,Microsoft.Build*}.dll"],
         Dir[".dotnet/sdk/*"].first
      # `build.sh` builds MSBuild again into the same directory
      rm_r "src/msbuild/artifacts"
    end
    system "./prep-source-build.sh"
    system "./build.sh", *args
    buildpath.install "artifacts/assets/Release"
  end

  def install
    # Make sure CoreCLR builds with our compiler shims
    ENV["CLR_CC"] = which(ENV.cc)
    ENV["CLR_CXX"] = which(ENV.cxx)
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    if OS.mac?
      # Need GNU grep (Perl regexp support) to use release manifest rather than git repo
      ENV.prepend_path "PATH", formula_opt_libexec("grep")/"gnubin"

      # Avoid mixing CLT and Xcode.app when building CoreCLR component which can
      # cause undefined symbols, e.g. __swift_FORCE_LOAD_$_swift_Builtin_float
      ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
      ENV.append_path "LD_LIBRARY_PATH", formula_opt_lib(icu4c_dep.name)
    end

    odie "Update 1xx and/or 1xx-manifest resource!" if resource("1xx").version != resource("1xx-manifest").version
    (buildpath/"dotnet").install resource("1xx"), resource("1xx-manifest")

    release = JSON.parse(File.read("release.json"))["release"]
    release_1xx = JSON.parse(File.read("dotnet/release.json"))["release"]
    odie "1xx resource uses .NET Runtime #{release_1xx} but was expecting #{release}!" if release != release_1xx

    cd "dotnet" do
      # Skip installer build on macOS - prevents CreatePkg target errors
      # See: https://github.com/dotnet/runtime/issues/122832
      if OS.mac?
        inreplace ["src/aspnetcore/Directory.Build.props", "src/runtime/Directory.Build.props"],
                  "</Project>",
                  "<PropertyGroup>\n    <SkipInstallerBuild>true</SkipInstallerBuild>\n  </PropertyGroup>\n</Project>"
      end

      bootstrap_build
    end

    mkdir "1xx-artifacts"
    system "tar", "-ozxvf", Dir["Release/Private.SourceBuilt.Artifacts.*.tar.gz"].first, "-C", "1xx-artifacts"
    rm_r(["Release", "dotnet"])
    (buildpath/"dotnet").install resource("src"), "release.json"

    cd "dotnet" do
      bootstrap_build with_shared_components: buildpath/"1xx-artifacts"
    end

    libexec.mkpath
    tarball = buildpath.glob("Release/dotnet-sdk-*.tar.gz").first
    system "tar", "--extract", "--file", tarball, "--directory", libexec

    if OS.linux?
      # Source-only builds default `KeepNativeSymbols` to true, so the native
      # binaries keep their DWARF. That leaves build paths in the binaries and
      # adds hundreds of MB to the x86_64 bottle. Upstream asks packagers to
      # strip downstream rather than flip that switch, see
      # https://github.com/dotnet/source-build/blob/main/Documentation/debugging-support.md
      # `--strip-debug` keeps `.symtab`, so native frames still symbolise, and
      # unlike an `--only-keep-debug` split it leaves no `.dbg` files behind.
      native_binaries = libexec.glob("**/*").select { |path| path.file? && path.elf? }
      system "strip", "--strip-debug", "--preserve-dates", *native_binaries
    end

    doc.install libexec.glob("*.txt")
    (bin/"dotnet").write_env_script libexec/"dotnet", DOTNET_ROOT: libexec

    bash_completion.install "dotnet/src/sdk/scripts/register-completions.bash" => "dotnet"
    zsh_completion.install "dotnet/src/sdk/scripts/register-completions.zsh" => "_dotnet"
    man1.install Utils::Gzip.compress(*buildpath.glob("dotnet/src/sdk/documentation/manpages/sdk/*.1"))
    man7.install Utils::Gzip.compress(*buildpath.glob("dotnet/src/sdk/documentation/manpages/sdk/*.7"))
  end

  def caveats
    <<~CAVEATS
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    CAVEATS
  end

  test do
    ENV["XDG_RUNTIME_DIR"] = testpath

    assert_match version.to_s, shell_output("#{bin}/dotnet --version")

    target_framework = "net#{version.major_minor}"

    (testpath/"test.cs").write <<~CS
      using System;

      namespace Homebrew
      {
        public class Dotnet
        {
          public static void Main(string[] args)
          {
            var joined = String.Join(",", args);
            Console.WriteLine(joined);
          }
        }
      }
    CS

    (testpath/"test.csproj").write <<~XML
      <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
          <OutputType>Exe</OutputType>
          <TargetFrameworks>#{target_framework}</TargetFrameworks>
          <PlatformTarget>AnyCPU</PlatformTarget>
          <RootNamespace>Homebrew</RootNamespace>
          <PackageId>Homebrew.Dotnet</PackageId>
          <Title>Homebrew.Dotnet</Title>
          <Product>$(AssemblyName)</Product>
          <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="test.cs" />
        </ItemGroup>
      </Project>
    XML

    system bin/"dotnet", "build", "--framework", target_framework, "--output", testpath, testpath/"test.csproj"
    output = shell_output("#{bin}/dotnet run --framework #{target_framework} #{testpath}/test.dll a b c")
    assert_equal "#{testpath}/test.dll,a,b,c\n", output

    # Test to avoid uploading broken bottle, see https://github.com/Homebrew/homebrew-core/issues/197546
    resource("docfx").stage do
      system bin/"dotnet", "restore", "src/docfx", "--disable-build-servers", "--no-cache",
                                                   "-p:TargetFrameworks=net#{version.major_minor}"
    end
  end
end
