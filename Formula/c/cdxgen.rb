class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/cdxgen/cdxgen"
  url "https://registry.npmjs.org/@cdxgen/cdxgen/-/cdxgen-13.7.0.tgz"
  sha256 "47b1ff1c7277a5c620495d4731fe2d63368fa28896039201ea8abfcbc94d9b82"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "81e0d3798bec7bebe3200372a514e58f1238e3cfc58f01f45bbb56fc8e1ca0ab"
    sha256               arm64_tahoe:       "73bcd50d6b955c9d685aacae58b522275ee94327e0aa17ed20b16567f8276fde"
    sha256               arm64_sequoia:     "f8eb4251f9ced60c6f05cb62b6f9f8a0d5fb72148d74736d7f1f378b6a3bd9cd"
    sha256 cellar: :any, arm64_linux:       "3c1fad323793afaacdbc81a92b1d825541a1363e18ad16f554c5807cda1bfb5c"
    sha256 cellar: :any, x86_64_linux:      "6be41293152c964c884ce1d269e22f4585041bf7099785a48356789fafa43848"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "trivy"

  resource "dosai" do
    url "https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v4.1.0.tar.gz"
    sha256 "f988bda63f1fd6b648f4bd177bb8b1526b953434735a75d9590b9ebfcaca98f9"
  end

  # For `npm` and `dotnet`
  allow_network_access! :build

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+(\.\d+)*)?$/) }.to_formula

  def ruby = deps.map(&:name).find { |d| d.match?(/^ruby(@\d+(\.\d+)*)?$/) }

  def install
    # https://github.com/cdxgen/cdxgen/blob/master/lib/managers/binary.js
    # https://github.com/AppThreat/atom/blob/main/wrapper/nodejs/rbastgen.js
    cdxgen_env = {
      RUBY_CMD:         "${RUBY_CMD:-#{formula_opt_bin(ruby)}/ruby}",
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

    resource("dosai").stage do
      ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
      # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
      ENV["XDG_RUNTIME_DIR"] = buildpath
      dosai_cmd = "dosai-#{os}-#{arch}"
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
