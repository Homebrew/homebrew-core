class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.2.5.tgz"
  sha256 "1874b25e03f5e16ef3fe53ec27cd89bb5b970dd118162b245699c74a9a9667a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "907777fa32749058d41eba538348da083d9a075c16295fdd6f852cf9023ff84b"
    sha256 cellar: :any,                 arm64_sonoma:  "591fea9be5888cd3cbcb6835cc37488a28b330336b1f123d15770704603d2dcc"
    sha256 cellar: :any,                 arm64_ventura: "7ab626cba58ae4e4e987c950e2f623d74d139b339d73f9401ce7ac8a34540092"
    sha256 cellar: :any,                 ventura:       "96bcfd988cfa43d8f26183b7bdeb0793d2f0843eff234740272d5e26724d5750"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c54a4354af322e628269190d0ac31c140263b1ef638109c989f8970e91882c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b50c9143954910159f39fb0d31600974cb3492327933fa8795c06ac7b5153bd"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "sqlite" # needs sqlite3_enable_load_extension
  depends_on "trivy"

  resource "dosai" do
    url "https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v1.0.2.tar.gz"
    sha256 "8dee3b328f58c75b62be9acbc26e00d6932599985c47588feb323c900fba6688"
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

    # Ignore specific Ruby patch version and reinstall for native dependencies
    inreplace node_modules/"@appthreat/atom/rbastgen.js", /(RUBY_VERSION_NEEDED = ")[\d.]+"/, "\\1\""
    cd node_modules/"@appthreat/atom/plugins/rubyastgen" do
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
