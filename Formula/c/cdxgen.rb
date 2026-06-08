class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-12.5.1.tgz"
  sha256 "864e8d9d3e85d1eb3485f1f44952ff67b9f91255b3893736f2068fdbfdb5ec78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2cfe105e7f690765cd13e5985d8bdaaca321d52fd9dd15dbe92d8060b62a0195"
    sha256 cellar: :any, arm64_sequoia: "84a7fc3c38c51a629bcc2095bff2cfa5f04cce8c5d5e36ce799c1eec6d3476d9"
    sha256 cellar: :any, arm64_sonoma:  "1d9942f5e1bfc12595564755f4b647da64da0350d9d9ba1a350da29e12267fbc"
    sha256 cellar: :any, sonoma:        "6a3147d2fdb62a397a92a5d263a26f9128dbf6900833a8b9920eb0773dcad103"
    sha256 cellar: :any, arm64_linux:   "973c7841424f5c0e031bf774dc3dfd174c4ae728ed337271e44ceaea9df797f7"
    sha256 cellar: :any, x86_64_linux:  "7932c7cc1e835287e5440c46de5bfef390e3aec005acea1e3e956a3c251a7c3f"
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
    # https://github.com/CycloneDX/cdxgen/blob/master/lib/managers/binary.js
    # https://github.com/AppThreat/atom/blob/main/wrapper/nodejs/rbastgen.js
    cdxgen_env = {
      RUBY_CMD:         "${RUBY_CMD:-#{Formula["ruby"].opt_bin}/ruby}",
      SOURCEKITTEN_CMD: "${SOURCEKITTEN_CMD:-#{Formula["sourcekitten"].opt_bin}/sourcekitten}",
      TRIVY_CMD:        "${TRIVY_CMD:-#{Formula["trivy"].opt_bin}/trivy}",
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
