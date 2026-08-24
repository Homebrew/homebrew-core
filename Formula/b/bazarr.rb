class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://github.com/morpheus65535/bazarr/releases/download/v1.6.0/bazarr.zip"
  sha256 "9c7523258bde58528d53acc91239774215e44e4f31d28cb2fb1c620ecdaef7b3"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fb73aad01bf88f7dd6cf654432b617e82db2cf403d6a508d36483b21d996d35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "646bbecf893d730ebde4bebf09b1d711b128868a30c76fe09dc2dc49245986b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2d742f231b7122b2922f85fbef50fdc9ccd15dc01cbef80c53ed1d78f019af9"
    sha256 cellar: :any_skip_relocation, sonoma:        "252eb55fbc8c0d43c04489a7a6572a32cd5c9d9f5dcff17751c8e22b20b36c7e"
    sha256 cellar: :any,                 arm64_linux:   "1b0dfc9b4b015f12e9501ef7c5b19379e69081a1231165571f019fd6f6821dbb"
    sha256 cellar: :any,                 x86_64_linux:  "9b9f3abba5c4be54a143a39f4644cdf85b47645e0ed727a49a0a60eb03e9058c"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
  depends_on "unar"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: ["lxml", "setuptools", "webrtcvad-wheels"]

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "webrtcvad-wheels" do
    url "https://files.pythonhosted.org/packages/28/ba/3a8ce2cff3eee72a39ed190e5f9dac792da1526909c97a11589590b21739/webrtcvad_wheels-2.0.14.tar.gz"
    sha256 "5f59c8e291c6ef102d9f39532982fbf26a52ce2de6328382e2654b0960fea397"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources

    if build.head?
      # Build front-end.
      cd buildpath/"frontend" do
        system "npm", "install", *std_npm_args(prefix: false)
        system "npm", "run", "build"
      end
    end

    # Stop program from automatically downloading its own binaries.
    binaries_file = buildpath/"bazarr/utilities/binaries.json"
    binaries_file.unlink
    binaries_file.write "[]"

    # Prevent strange behavior of searching for a different python executable on macOS,
    # which won't have the required dependencies
    inreplace "bazarr.py", "def get_python_path():", "def get_python_path():\n    return sys.executable"

    libexec.install Dir["*"]
    (bin/"bazarr").write_env_script venv.root/"bin/python", "#{libexec}/bazarr.py",
      NO_UPDATE:  "1",
      PATH:       "#{formula_opt_bin("ffmpeg")}:#{HOMEBREW_PREFIX}/bin:${PATH}",
      PYTHONPATH: venv.site_packages

    pkgvar = var/"bazarr"
    pkgvar.mkpath
    pkgvar.install_symlink pkgetc => "config"

    pkgetc.mkpath
    cp Dir[libexec/"data/config/*"], pkgetc

    libexec.install_symlink pkgvar => "data"

    (buildpath/"config.ini").write <<~INI
      [backup]
      folder = #{pkgvar}/backup
    INI
    pkgetc.install "config.ini"
  end

  service do
    run opt_bin/"bazarr"
    keep_alive true
    require_root true
    log_path var/"log/bazarr.log"
    error_log_path var/"log/bazarr.log"
  end

  test do
    require "open3"
    require "timeout"

    system bin/"bazarr", "--help"

    (testpath/"config/config.ini").write <<~INI
      [backup]
      folder = #{testpath}/custom_backup
    INI

    port = free_port

    Open3.popen3(bin/"bazarr", "--no-update", "--config", testpath, "--port", port.to_s) do |_, _, stderr, wait_thr|
      Timeout.timeout(45) do
        stderr.each do |line|
          refute_match "ERROR", line unless line.match? "Error trying to get releases from Github"
          break if line.include? "BAZARR is started and waiting for requests on: http://***.***.***.***:#{port}"
        end
        assert_match "<title>Bazarr</title>", shell_output("curl --silent http://localhost:#{port}")
      end
    ensure
      Process.kill "TERM", wait_thr.pid
    end

    assert_path_exists (testpath/"config/config.ini.old")
    assert_includes (testpath/"config/config.yaml").read, testpath/"custom_backup"
    assert_match "BAZARR is started and waiting for request", (testpath/"log/bazarr.log").read
  end
end
