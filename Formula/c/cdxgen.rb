class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-12.8.1.tgz"
  sha256 "b79c7f486c243bd81499fa08719957883a55210c108d8997500ba7862fd8a2d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8ab19e84b8fe05ba0defc5f032e5c9ce826d799baf4538a9738f0121d717b396"
    sha256 cellar: :any, arm64_sequoia: "d0be07b0d72823e6aa43c344b7316dc501ad2417bf38d73279f8a323a474f1e7"
    sha256 cellar: :any, arm64_sonoma:  "77c6d6dbb7fa7768a1b70e0f0e304948546490986925250a581f9849619bac79"
    sha256 cellar: :any, sonoma:        "740e05f2cfd90bfb25ae98cf67de0570db122205980bca82f098dcfee166153b"
    sha256 cellar: :any, arm64_linux:   "9cd5ab0c77584a4f93de91fe6fc71fb56109962a0af6b9e6986b1f6d11ad9997"
    sha256 cellar: :any, x86_64_linux:  "18069eb202f2675d0f5a874aff6652605bc8943928e9a41fa3c6d338c380a53e"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "trivy"

  resource "dosai" do
    url "https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v3.0.5.tar.gz"
    sha256 "38229e1c3a909e18a76aea6dd126ce7d148c2787da8fdc431857db2af2b83715"
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

    chmod 0555, bin/"cdxgen"
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
