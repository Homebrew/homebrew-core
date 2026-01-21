class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-12.0.0.tgz"
  sha256 "9e9aa47d26cd7a0f44c9741186ccd8d6d755bc89c76c3df0dca06fa8d688a6dd"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36811a347d3c40b216f50d30a1334c5ec6568c2097a0486552cf609862f513fb"
    sha256 cellar: :any,                 arm64_sequoia: "911ada4d8598436cbd72b0b4d32483af6a0f1b65bd2c390614bd9bbf56665a42"
    sha256 cellar: :any,                 arm64_sonoma:  "5282d20746caec231c9993bfbcefc113e4519bfbff139e75fe3f156fe3424864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaa701a4e6335f0ea902fe309645304543b792c9b1e3ae70b8852de6d1dfa86d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "396a6de5b3fee4099490ef33d5c7cc6a0427cc13d19160da87a697127d86f384"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "sqlite" # needs sqlite3_enable_load_extension
  depends_on "trivy"

  resource "dosai" do
    url "https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v2.0.3.tar.gz"
    sha256 "c66f96ab143e5e62262b963142b55f9ca7ae6708d175f62c0130b805dac226a5"
  end

  def install
    # https://github.com/CycloneDX/cdxgen/blob/master/lib/managers/binary.js
    # https://github.com/AppThreat/atom/blob/main/wrapper/nodejs/rbastgen.js
    cdxgen_env = {
      RUBY_CMD:         "${RUBY_CMD:-#{Formula["ruby"].opt_bin}/ruby}",
      SOURCEKITTEN_CMD: "${SOURCEKITTEN_CMD:-#{Formula["sourcekitten"].opt_bin}/sourcekitten}",
      TRIVY_CMD:        "${TRIVY_CMD:-#{Formula["trivy"].opt_bin}/trivy}",
    }

    system "npm", "install", "--sqlite=#{Formula["sqlite"].opt_prefix}", *std_npm_args
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", cdxgen_env

    # Remove/replace pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin-#{os}-#{arch}/plugins"
    rm_r(cdxgen_plugins/"dosai")
    rm_r(cdxgen_plugins/"sourcekitten")
    rm_r(cdxgen_plugins/"trivy")
    # Remove pre-built osquery plugins for macOS arm builds
    rm_r(cdxgen_plugins/"osquery") if OS.mac? && Hardware::CPU.arm?

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

    # Reinstall for native dependencies
    cd node_modules/"@appthreat/atom-parsetools/plugins/rubyastgen" do
      rm_r("bundle")
      system "./setup.sh"
    end
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
