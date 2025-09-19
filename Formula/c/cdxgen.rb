class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.7.0.tgz"
  sha256 "875653ff9da5fb55781d4828368f1c7181698bc1fe3c9180207a5a161a6deea0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf21ff97cdb42abbcdd56257b33d9ed337fabaf8426d9cef60d7ea5f33245a52"
    sha256 cellar: :any,                 arm64_sequoia: "4ab5a6f5f75984fde5b7618e4b1bc364c638c15a8c48dba7f3e30a973341781c"
    sha256 cellar: :any,                 arm64_sonoma:  "7916347df7958f271b13ffa898416dbd993bc77d1153def683824c73d6c3d7d5"
    sha256 cellar: :any,                 arm64_ventura: "1d1d7ea4b2726aaa9776c3f29fc29df7c05aafec58976e81eb4314022419dcbe"
    sha256 cellar: :any,                 ventura:       "d7cfd9209c9e480e701efa5b6833eff93362a03ef8c869eb2e79ef71887b9952"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d0620f5d55aef14f83590f3fe88bbcdca0452fd9a9134f2afdff158c5b7892b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0873c530ebd27b3bbd79df7d172045191b3d3292542f637eb3ad22e6ddbcbb45"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "sqlite" # needs sqlite3_enable_load_extension
  depends_on "trivy"

  resource "dosai" do
    url "https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v1.0.5.tar.gz"
    sha256 "7fa46508d4ac27203aa4d28da2f24aaca0e1ef7f2ce98a59df8296995c4bd1d7"
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
