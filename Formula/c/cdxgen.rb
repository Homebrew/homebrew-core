class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-12.8.4.tgz"
  sha256 "fe4787e12e4b261af5272ad0a1075cd6e24bfa2792a26c1916a0c806290bea13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "be31440d0b9729c7a5658e0c7b79be48e2a0a05bf241bf62e1726a0c234a3ca0"
    sha256 cellar: :any, arm64_sequoia: "3aa1bded5fdd24c04acd54e17208edf4a64597b80d9206aa7eb989b55d7f3ede"
    sha256 cellar: :any, arm64_sonoma:  "749c7f518fbcfe0a3f270ed86a13c954d0d9a40bca4d9d648a6719489fa2760d"
    sha256 cellar: :any, sonoma:        "23af74184e04ca52e9f17ad32dbda5b961e612ee072db1474b9423938727a42f"
    sha256 cellar: :any, arm64_linux:   "1c2a7aa4cf90bfb75a7edaddde3b08ee1e6863224e71d6fbcc0334c80abd3297"
    sha256 cellar: :any, x86_64_linux:  "00067faed521ef635df73aa8aeded45f6d71fe58a81b039fdf16edc9f14c2884"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "trivy"

  resource "dosai" do
    url "https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v3.0.6.tar.gz"
    sha256 "ab7a4338e2f14f8f357bca95497d086939a396012a3c3a0cbf39266c43668240"
  end

  def install
    # https://github.com/cdxgen/cdxgen/blob/master/lib/managers/binary.js
    # https://github.com/AppThreat/atom/blob/main/wrapper/nodejs/rbastgen.js
    cdxgen_env = {
      RUBY_CMD:         "${RUBY_CMD:-#{formula_opt_bin("ruby")}/ruby}",
      SOURCEKITTEN_CMD: "${SOURCEKITTEN_CMD:-#{formula_opt_bin("sourcekitten")}/sourcekitten}",
      TRIVY_CMD:        "${TRIVY_CMD:-#{formula_opt_bin("trivy")}/trivy}",
    }

    system "npm", "install", *std_npm_args
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", cdxgen_env

    # Remove/replace pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cdxgen/cdxgen-plugins-bin-#{os}-#{arch}/plugins"
    paths_to_remove = %w[dosai sourcekitten trivy].map { |plugin| cdxgen_plugins/plugin }
    # Remove pre-built osquery plugins for macOS arm builds
    paths_to_remove << (cdxgen_plugins/"osquery") if OS.mac? && Hardware::CPU.arm?

    resource("dosai").stage do
      ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
      dosai_cmd = "dosai-#{os}-#{arch}"
      dotnet = Formula["dotnet"]
      args = %W[
        --configuration Release
        --framework net#{dotnet.version.major_minor}
        --no-self-contained
        --output #{cdxgen_plugins}/dosai
        --use-current-runtime
        -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(cdxgen_plugins/"dosai")}
        -p:AssemblyName=#{dosai_cmd}
        -p:DebugType=None
        -p:PublishSingleFile=true
      ]
      system "dotnet", "publish", "Dosai", *args
    end

    rm_r(paths_to_remove)

    # Reinstall for native dependencies
    cd node_modules/"@appthreat/atom-parsetools/plugins/rubyastgen" do
      rm_r("bundle")
      system "./setup.sh"
    end

    generate_completions_from_executable(bin/"cdxgen", "completion", shell_parameter_format: :none,
                                                                     shells:                 [:bash, :zsh])
  end

  test do
    (testpath/"Gemfile.lock").write <<~EOS
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
    EOS

    assert_match "BOM includes 1 components and 2 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end
