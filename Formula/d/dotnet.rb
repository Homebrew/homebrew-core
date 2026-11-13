class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  license "MIT"
  version_scheme 1
  compatibility_version 9

  stable do
    # Source-build tag announced at https://github.com/dotnet/source-build/discussions
    url "https://github.com/dotnet/dotnet/releases/download/v11.0.100/release.json"
    sha256 "007b0ad9b0cf567e35fab4db99fd01310e906e8566f57b437141ca314edc30cd"

    resource "src" do
      url "https://github.com/dotnet/dotnet/archive/refs/tags/v11.0.100.tar.gz"
      sha256 "d133a74d6bb0b7eccdbfc96bf81950767691c08f88f9e25a374de92ab4d31b34"

      livecheck do
        formula :parent
      end

      on_macos do
        # FIXME: Workaround for brew sandbox. See if upstream can add support to override /tmp
        patch do
          file "Patches/dotnet/brew-sandbox-workaround.diff"
          type :unofficial
        end
      end
    end

    resource "1xx" do
      url "https://github.com/dotnet/dotnet/archive/refs/tags/v11.0.100.tar.gz"
      sha256 "d133a74d6bb0b7eccdbfc96bf81950767691c08f88f9e25a374de92ab4d31b34"

      livecheck do
        url "https://github.com/dotnet/dotnet/releases/download/v#{LATEST_VERSION}/release.json"
        regex(/^v?(\d+\.\d+\.1\d\d)$/i)
        strategy :json do |json, regex|
          channel_url = "https://builds.dotnet.microsoft.com/dotnet/release-metadata/#{json["channel"]}/releases.json"
          channel_json = JSON.parse(Homebrew::Livecheck::Strategy.page_content(channel_url)[:content])
          latest_release = channel_json["releases"]&.find { |release| release["release-version"] == json["release"] }
          next if latest_release.blank?

          latest_release["sdks"]&.filter_map do |sdk|
            sdk["version"]&.[](regex, 1)
          end
        end
      end

      on_macos do
        # FIXME: Workaround for brew sandbox. See if upstream can add support to override /tmp
        patch do
          file "Patches/dotnet/brew-sandbox-workaround.diff"
          type :unofficial
        end

        # FIXME: Skip installer build on macOS - prevents CreatePkg target errors
        patch do
          file "Patches/dotnet/skipinstallerbuild.diff"
          type :unofficial
          resolves "https://github.com/dotnet/runtime/issues/122832"
        end
      end

      # Avoid OpenSSL APIs missing from the shim with OpenSSL 4.1
      patch do
        url "https://github.com/dotnet/runtime/commit/d89205572858c883d9ab16a3089a13782e7f4d7e.patch?full_index=1"
        sha256 "9228a8475b8e6e2b21b007ef86fc059d0885f52cef456781a2b223e6767e6b36"
        directory "src/runtime"
        type :backport
        resolves "https://github.com/dotnet/runtime/pull/136435"
      end
    end

    resource "1xx-manifest" do
      url "https://github.com/dotnet/dotnet/releases/download/v11.0.100/release.json"
      sha256 "007b0ad9b0cf567e35fab4db99fd01310e906e8566f57b437141ca314edc30cd"

      livecheck do
        url "https://github.com/dotnet/dotnet/releases/download/v#{LATEST_VERSION}/release.json"
        regex(/^v?(\d+\.\d+\.1\d\d)$/i)
        strategy :json do |json, regex|
          channel_url = "https://builds.dotnet.microsoft.com/dotnet/release-metadata/#{json["channel"]}/releases.json"
          channel_json = JSON.parse(Homebrew::Livecheck::Strategy.page_content(channel_url)[:content])
          latest_release = channel_json["releases"]&.find { |release| release["release-version"] == json["release"] }
          next if latest_release.blank?

          latest_release["sdks"]&.filter_map do |sdk|
            sdk["version"]&.[](regex, 1)
          end
        end
      end
    end
  end

  # Check blob storage JSON so that resources' livechecks work during version bump
  livecheck do
    url "https://builds.dotnet.microsoft.com/dotnet/release-metadata/releases-index.json"
    regex(/^v?(\d+\.\d+\.\d{3})$/i)
    strategy :json do |json, regex|
      json["releases-index"]&.filter_map do |channel|
        next if channel["support-phase"] != "active"

        channel["latest-sdk"]&.[](regex, 1)
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c4655631dba711425bf87101607ad64d93d3dc0d893305ef2cca21bf3b424ac3"
    sha256 cellar: :any, arm64_tahoe:       "45d7cd5cdba40f600ca0267f018f7923cd302ea41d661abb76b723940866ef4e"
    sha256 cellar: :any, arm64_sequoia:     "60064902141f586b7b67968d0c2c37671340c28adde3ee8e99745639e86108da"
    sha256 cellar: :any, arm64_linux:       "452c9c63db77f394201c2c4f93e99cc155f354977b997ce393a620ecabee85f4"
    sha256 cellar: :any, x86_64_linux:      "115b6501fd45383a2da38e4e77458fdaac59cf8106e510012b69e187506087f9"
  end

  head do
    url "https://github.com/dotnet/dotnet.git", branch: "main"

    on_macos do
      depends_on xcode: :build # for xcodebuild
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "brotli"
  depends_on "icu4c@79"
  depends_on "openssl@4"
  depends_on "zstd"

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
    prep_args = %w[--no-shared-components] if with_shared_components
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

    # FIXME: Workaround for brew sandbox. See if upstream can add support to override /tmp
    on_macos do
      # `prep-source-build.sh` runs binary detection with the prebuilt SDK, so patch its MSBuild first
      system "./prep-source-build.sh", "--no-binary-removal", *prep_args
      # Avoid worker nodes and the task hosts of `Directory.Build.rsp`'s `/mt`,
      # which the unpatched bootstrap MSBuild cannot reach
      system ".dotnet/dotnet", "build", "src/msbuild/src/MSBuild/MSBuild.csproj", "--configuration", "Release",
             "-maxcpucount:1", "-noAutoResponse"
      # Replace the bootstrap SDK's MSBuild with the patched one
      cp Dir["src/msbuild/artifacts/bin/MSBuild/Release/net*/{MSBuild,Microsoft.Build*}.dll"],
         Dir[".dotnet/sdk/*"].first
      # `build.sh` builds MSBuild again into the same directory
      rm_r "src/msbuild/artifacts"
    end
    system "./prep-source-build.sh", *prep_args
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

    if build.head?
      (buildpath/"dotnet").install buildpath.children
    else
      odie "Update src resource to #{version}!" if version != resource("src").version
      odie "Update 1xx resource to #{version}!" if version != resource("1xx").version && version.patch.to_i < 200
      odie "Update 1xx and/or 1xx-manifest resource!" if resource("1xx").version != resource("1xx-manifest").version
      (buildpath/"dotnet").install resource("1xx"), resource("1xx-manifest")

      release = JSON.parse(File.read("release.json"))["release"]
      release_1xx = JSON.parse(File.read("dotnet/release.json"))["release"]
      odie "1xx resource uses .NET Runtime #{release_1xx} but was expecting #{release}!" if release != release_1xx
    end

    cd "dotnet" do
      bootstrap_build
    end

    if build.stable? && version.patch.to_i >= 200
      mkdir "1xx-artifacts"
      system "tar", "-ozxvf", Dir["Release/Private.SourceBuilt.Artifacts.*.tar.gz"].first, "-C", "1xx-artifacts"
      rm_r(["Release", "dotnet"])
      (buildpath/"dotnet").install resource("src"), "release.json"

      cd "dotnet" do
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

    # Test to avoid uploading broken bottle, see https://github.com/Homebrew/homebrew-core/issues/197546
    resource("docfx").stage do
      system bin/"dotnet", "restore", "src/docfx", "--disable-build-servers", "--no-cache"
    end
  end
end
