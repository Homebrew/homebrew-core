class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-12.3.3.tgz"
  sha256 "ce823534d3d0afb405123a401c8cd3358d1eff19f2e0444a9b8e8477b4361641"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0784cab9f55be1cbf8f34e2d7b06340d45eeb55ca2e387364544e8182e7e291f"
    sha256 cellar: :any,                 arm64_sequoia: "8dbf897b0c621ddbbc164bbe33aa4f10c4a84c2735ae1a7da6a240413656fd6d"
    sha256 cellar: :any,                 arm64_sonoma:  "1fe79d6abe31fa658342a3735484903d2fc2aa58fa6106cc0d42b25e60fa5b63"
    sha256 cellar: :any,                 sonoma:        "fa97d616aea00bdfa8168d8463f9080af4db4038f0c394895ca5a7bfa3cb6993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c1157c315c2c89b61bcc1da25ba69d62971271b17eb3f622b20438a35dbd8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95ebc72111d3d65eca0507be57462240409fc6d0eea113541028846865df2ea"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "trivy"

  resource "dosai" do
    url "https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v2.1.1.tar.gz"
    sha256 "b17b6abdf651e50aea6de4b7652ac5b902ef268a8d33e9b5c47fc687bcd6c5a7"
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
