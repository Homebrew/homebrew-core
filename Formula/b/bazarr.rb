class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://github.com/morpheus65535/bazarr/releases/download/v1.4.3/bazarr.zip"
  sha256 "b664dd9947d1051941d788ee371528eb945efbd6a05015f40414ae36ede9482d"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0f8672138939fa50ef1f6b228cb57a66e8bd15f270aebbaeed175adec2bd78ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b023d5c160d3c58237cd18c8ce142b47f94725ab26f9849f9161401cd416c33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5a5ccc8ae165f93dd193cb14cdbdb489eb800fc57f2da84c33fbc3b12be29fd"
    sha256 cellar: :any,                 arm64_monterey: "99e22f87a17d46593ac22ebca997d18d25bc1d7885871b4a3afcc65a53794b45"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c97ed102759a6ea084b277f13bce79792ea13ca159d55df7a06c86d19e094ba"
    sha256 cellar: :any_skip_relocation, ventura:        "bad9d45c6e1f7292549859ddc2a2461b32293fa6f42cc29cc1620dd93d9a5ec4"
    sha256 cellar: :any,                 monterey:       "18350639a3711e8a8059aaa5af057473dc833dc9894917c5e57cfa800a8857d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5757b9d197bca66cac1645c719d2f8f2f0c74397f0bf39177d4428f9dbe4075"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "gcc"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "unar"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/5e/11/487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1d/setuptools-72.1.0.tar.gz"
    sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
  end

  resource "webrtcvad-wheels" do
    url "https://files.pythonhosted.org/packages/59/d9/17fe64f981a2d33c6e95e115c29e8b6bd036c2a0f90323585f1af639d5fc/webrtcvad-wheels-2.0.11.post1.tar.gz"
    sha256 "aa1f749b5ea5ce209df9bdef7be9f4844007e630ac87ab9dbc25dda73fd5d2b7"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
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
    (bin/"bazarr").write_env_script venv.root/"bin/python", libexec/"bazarr.py",
      NO_UPDATE:  "1",
      PATH:       "#{Formula["ffmpeg"].opt_bin}:#{HOMEBREW_PREFIX/"bin"}:$PATH",
      PYTHONPATH: venv.site_packages

    pkgvar = var/"bazarr"
    pkgvar.mkpath
    pkgvar.install_symlink pkgetc => "config"

    pkgetc.mkpath
    cp Dir[libexec/"data/config/*"], pkgetc

    libexec.install_symlink pkgvar => "data"
  end

  def post_install
    pkgvar = var/"bazarr"

    config_file = pkgetc/"config.ini"
    unless config_file.exist?
      config_file.write <<~EOS
        [backup]
        folder = #{pkgvar}/backup
      EOS
    end
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

    (testpath/"config/config.ini").write <<~EOS
      [backup]
      folder = #{testpath}/custom_backup
    EOS

    port = free_port

    Open3.popen3(bin/"bazarr", "--no-update", "--config", testpath, "-p", port.to_s) do |_, _, stderr, wait_thr|
      Timeout.timeout(45) do
        stderr.each do |line|
          refute_match "ERROR", line unless line.match? "Error trying to get releases from Github"
          break if line.include? "BAZARR is started and waiting for request on http://0.0.0.0:#{port}"
        end
        assert_match "<title>Bazarr</title>", shell_output("curl --silent http://localhost:#{port}")
      end
    ensure
      Process.kill "TERM", wait_thr.pid
    end

    assert_predicate (testpath/"config/config.ini.old"), :exist?
    assert_includes (testpath/"config/config.yaml").read, "#{testpath}/custom_backup"
    assert_match "BAZARR is started and waiting for request", (testpath/"log/bazarr.log").read
  end
end
