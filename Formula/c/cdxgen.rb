class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/cdxgen/cdxgen"
  url "https://registry.npmjs.org/@cdxgen/cdxgen/-/cdxgen-13.9.0.tgz"
  sha256 "4b35859ecefebb71db08883817c59f5e94209d8682605fcfc2318821c579f718"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "e5d20fe8657f0a629c5e21ee70aefeb3ea0422befb51f00e87c1cef619f75135"
    sha256               arm64_golden_gate: "185a939aa73b7ccf186a55c48f2c0b457c394f59ccd96b136783f06cb5c1bd0c"
    sha256               arm64_tahoe:       "d96d07c950fa5238b56a270960da0363a6bb4557c0ce284493e55bb3e47e8df4"
    sha256               arm64_sequoia:     "0dc6fa86186f59129466c761844aa79f9b5aa27ffc2a3ba0f6f322ec41214746"
    sha256 cellar: :any, arm64_linux:       "90c857f00bf5be72a665d65c2268fa7ddd59121a430fe5917541ab8bc5961e39"
    sha256 cellar: :any, x86_64_linux:      "d1a23b02af3cb7a58ed9bf7a26fc2d31b169d47e1de157543e707b40947d7849"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "trivy"

  resource "dosai" do
    url "https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v5.0.0.tar.gz"
    sha256 "e2c431ef8ca2e6bbac8a2c1325a856e7ec8a38c3f0155817ed409589d68bdaa8"
  end

  # For `npm` and `dotnet`
  allow_network_access! :build

  def dotnet = dep("dotnet").to_formula

  def install
    # https://github.com/cdxgen/cdxgen/blob/master/lib/managers/binary.js
    # https://github.com/AppThreat/atom/blob/main/wrapper/nodejs/rbastgen.js
    ruby_bin = dep("ruby").opt_bin
    cdxgen_env = {
      RUBY_CMD:         "${RUBY_CMD:-#{ruby_bin}/ruby}",
      SOURCEKITTEN_CMD: "${SOURCEKITTEN_CMD:-#{formula_opt_bin("sourcekitten")}/sourcekitten}",
      TRIVY_CMD:        "${TRIVY_CMD:-#{formula_opt_bin("trivy")}/trivy}",
    }

    system "npm", "install", *std_npm_args
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", cdxgen_env

    # Remove/replace pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cdxgen/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cdxgen/cdxgen-plugins-bin-#{os}-#{arch}/plugins"
    paths_to_remove = %w[dosai trivy].map { |plugin| cdxgen_plugins/plugin }
    # Pre-built sourcekitten is only shipped for macOS
    paths_to_remove << (cdxgen_plugins/"sourcekitten") if OS.mac?
    # Remove pre-built osquery plugins for macOS arm builds
    paths_to_remove << (cdxgen_plugins/"osquery") if OS.mac? && Hardware::CPU.arm?

    rm_r(paths_to_remove)

    resource("dosai").stage do
      ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
      # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
      ENV["XDG_RUNTIME_DIR"] = buildpath
      dosai_cmd = "dosai-#{os}-#{arch}"
      # .NET 11 SDK fails to bundle a single-file app with `AppHostRelativeDotNet`
      dotnet_path = dotnet.opt_libexec.relative_path_from(cdxgen_plugins/"dosai")
      args = %W[
        --configuration Release
        --framework net#{dotnet.version.major_minor}
        --no-self-contained
        --output #{cdxgen_plugins}/dosai
        --use-current-runtime
        -p:AppHostRelativeDotNet=#{dotnet_path}
        -p:AssemblyName=#{dosai_cmd}
        -p:DebugType=None
        -p:PublishSingleFile=false
      ]
      system "dotnet", "publish", "Dosai", *args
    end

    # Reinstall for native dependencies
    cd node_modules/"@appthreat/atom-parsetools/plugins/rubyastgen" do
      rm_r("bundle")
      system "./setup.sh"
    end

    generate_completions_from_executable(bin/"cdxgen", "completion", shell_parameter_format: :none,
                                                                     shells:                 [:bash, :zsh])
  end

  test do
    (testpath/"Gemfile.lock").write <<~LOCK
      GEM
        remote: https://rubygems.org/
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    LOCK

    assert_match "BOM includes 2 components and 2 dependencies", shell_output("#{bin}/cdxgen -p 2>&1")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end
