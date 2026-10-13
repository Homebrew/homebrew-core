class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  license "MIT"
  version_scheme 1
  compatibility_version 8

  stable do
    # Source-build tag announced at https://github.com/dotnet/source-build/discussions
    url "https://github.com/dotnet/dotnet/releases/download/v10.0.402/release.json"
    sha256 "ef4ec1aab8a6e5305858afe4a6f42dcb80b9785369c5b81100ddf1acee7cd5fe"

    resource "src" do
      url "https://github.com/dotnet/dotnet/archive/refs/tags/v10.0.402.tar.gz"
      sha256 "b4d1a01dd142fc8a726b0e9ec7488571dbab10624b498bea8183379ccd008b29"

      livecheck do
        formula :parent
      end
    end

    # NOTE: 1xx band resources are only used when on 2xx/3xx/4xx band.
    # Can leave in formula even when unused to simplify version bumps.
    resource "1xx" do
      url "https://github.com/dotnet/dotnet/archive/refs/tags/v10.0.113.tar.gz"
      sha256 "5c3a5dcc776c94d314853ccf24d3a2b5627f2249c7defb8a8f0cbade8ecd4631"

      livecheck do
        url "https://github.com/dotnet/dotnet/releases/download/v#{LATEST_VERSION}/release.json"
        strategy :json do |json|
          channel_url = "https://builds.dotnet.microsoft.com/dotnet/release-metadata/#{json["channel"]}/releases.json"
          channel_json = JSON.parse(Homebrew::Livecheck::Strategy.page_content(channel_url)[:content])
          latest_release = channel_json["releases"].find { |release| release["release-version"] == json["release"] }
          latest_release["sdks"].filter_map do |sdk|
            v = Version.new(sdk["version"])
            v if v.patch.to_i.between?(100, 199)
          end
        end
      end

      # Backport OpenSSL 4 support
      patch do
        url "https://github.com/dotnet/runtime/commit/73ae2764c385c0f7dd6ecd53aeaa961fd6db508c.patch?full_index=1"
        sha256 "5238ab26337672635a0ffc969680ef1db8399fa38e769a563a01a39568dbaf28"
        directory "src/runtime"
        type :backport
        resolves "https://github.com/dotnet/runtime/pull/135534"
      end
    end

    resource "1xx-manifest" do
      url "https://github.com/dotnet/dotnet/releases/download/v10.0.113/release.json"
      sha256 "fbfc8572118e518be6ef736f143ffeb9b0c3bd872c9b34689a04f0ffde54b6e7"

      livecheck do
        url "https://github.com/dotnet/dotnet/releases/download/v#{LATEST_VERSION}/release.json"
        strategy :json do |json|
          channel_url = "https://builds.dotnet.microsoft.com/dotnet/release-metadata/#{json["channel"]}/releases.json"
          channel_json = JSON.parse(Homebrew::Livecheck::Strategy.page_content(channel_url)[:content])
          latest_release = channel_json["releases"].find { |release| release["release-version"] == json["release"] }
          latest_release["sdks"].filter_map do |sdk|
            v = Version.new(sdk["version"])
            v if v.patch.to_i.between?(100, 199)
          end
        end
      end
    end
  end

  # Upstream has unstable tags that use the same version scheme as stable
  # releases so we cannot use the default :git strategy.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.\d{3})$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fd2793f413fe9f83ace182f636abd8d44184185d80dc8e1fd23527934479b33b"
    sha256 cellar: :any, arm64_tahoe:       "5ff0fd2eee7bf478f5bd546c21a9c723f0800365facdff1b430e1cc9404ffb1f"
    sha256 cellar: :any, arm64_sequoia:     "8cf597a57a7b49286aa0c52f9c3f5f41a50232e892214eda60bdfe80bd4fbed9"
    sha256 cellar: :any, arm64_linux:       "54bdde5fe4b356fd19493f892389d3e79ca963de0b9c3640f7824c460a928814"
    sha256 cellar: :any, x86_64_linux:      "66a2980731a0f7e1a51e9cb12cab3eea87a2a2c251a4c88371b15179fdfc52fa"
  end

  head do
    url "https://github.com/dotnet/dotnet.git", branch: "main"

    depends_on "ninja" => :build
    depends_on "zstd"

    on_macos do
      depends_on xcode: :build # for xcodebuild
    end
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "brotli"
  depends_on "icu4c@78"
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

  # Perform "1xx" or "2xx/3xx/4xx" Band Bootstrap. Skipping stage 2 as didn't work via documented steps
  # https://github.com/dotnet/source-build/blob/main/Documentation/feature-band-source-building.md
  def bootstrap_build(with_shared_components: nil)
    args = %w[
      --clean-while-building
      --source-only
      --with-system-libs all
    ]
    args += ["--release-manifest", "release.json"] if build.stable?
    args += ["--with-shared-components", with_shared_components] if with_shared_components
    on_linux do
      args << "-p:PortableBuild=true"
    end

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

  # Test to avoid uploading broken Intel Sonoma bottle which has stack overflow on restore.
  # See https://github.com/Homebrew/homebrew-core/issues/197546
  resource "docfx", :test do
    url "https://github.com/dotnet/docfx/archive/refs/tags/v2.78.5.tar.gz"
    sha256 "79f9e2c4bb8de2225d91a812a4e9d2cc71a8ed5613b3b4b2940d2a1d5db38793"
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
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib
    end

    if build.head?
      (buildpath/"dotnet").install buildpath.children
    elsif version.patch.to_i < 200
      (buildpath/"dotnet").install resource("src"), "release.json"
    else
      (buildpath/"dotnet").install resource("1xx"), resource("1xx-manifest")

      release = JSON.parse(File.read("release.json"))["release"]
      release_1xx = JSON.parse(File.read("dotnet/release.json"))["release"]
      odie "1xx resource uses .NET Runtime #{release_1xx} but was expecting #{release}!" if release != release_1xx
      odie "Update 1xx and/or 1xx-manifest resource!" if resource("1xx").version != resource("1xx-manifest").version
    end

    cd "dotnet" do
      if build.stable?
        # Fixes build error where member names shadow type names
        # Error: declaration of '...' changes meaning of '...'
        inreplace "src/runtime/src/coreclr/jit/gentree.h" do |s|
          s.gsub! "    ExecutionContextHandling    ExecutionContextHandling",
                  "    ::ExecutionContextHandling    ExecutionContextHandling"
          s.gsub! "= ExecutionContextHandling::None;",
                  "= ::ExecutionContextHandling::None;"

          s.gsub! "    ContinuationContextHandling ContinuationContextHandling",
                  "    ::ContinuationContextHandling ContinuationContextHandling"
          s.gsub! "= ContinuationContextHandling::None;",
                  "= ::ContinuationContextHandling::None;"
        end
      end

      # Skip installer build on macOS - prevents CreatePkg target errors
      # See: https://github.com/dotnet/runtime/issues/122832
      if OS.mac?
        inreplace ["src/aspnetcore/Directory.Build.props", "src/runtime/Directory.Build.props"],
                  "</Project>",
                  "<PropertyGroup>\n    <SkipInstallerBuild>true</SkipInstallerBuild>\n  </PropertyGroup>\n</Project>"
      end

      bootstrap_build
    end

    if build.stable? && version.patch.to_i >= 200
      mkdir "1xx-artifacts"
      system "tar", "-ozxvf", Dir["Release/Private.SourceBuilt.Artifacts.*.tar.gz"].first, "-C", "1xx-artifacts"
      rm_r(["Release", "dotnet"])
      (buildpath/"dotnet").install resource("src"), "release.json"

      cd "dotnet" do
        chmod "+x", "src/diagnostics/eng/common/build.sh"
        bootstrap_build with_shared_components: buildpath/"1xx-artifacts"
      end
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

    resource("docfx").stage do
      system bin/"dotnet", "restore", "src/docfx", "--disable-build-servers", "--no-cache"
    end
  end
end
