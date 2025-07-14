class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://github.com/morpheus65535/bazarr/releases/download/v1.5.2/bazarr.zip"
  sha256 "63519d9855e5b84c947b18d72fa36dfa9341a040879d1079bfde2fabfe8ab30e"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "development"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a970f6f5dc0730e20ca59176874c7ec1abe7a8433a897bd0e642eba8a951c00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203e8edb199ebd6050879d45b5dca2e37baa282b8e48dbcf6f3c1b8269ec05ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12bf4455d2154c9fcc5f719a321bda609ee2610a5a897384230ba8918865e024"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7bd2789e41974a78525fb2ed9e4f384b9c337977652375b22b9cc87b974f7ca"
    sha256 cellar: :any_skip_relocation, ventura:       "2d822e4808509bc37dfc0ec0ef20dbd49bbc9d74eda582b31b1beeac80f2a9e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b43a4b85eaa37c9e87a5d5ac1b0b4ff729aff6d4bd3c583958056c5fba741a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61178b07eb006f26c6a92ebad8daf2da402070d91d0dd54a54705dd592674d3b"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "gcc"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12" # Python 3.13 issue (closed w/o fix): https://github.com/morpheus65535/bazarr/issues/2803
  depends_on "unar"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/95/32/0cc40fe41fd2adb80a2f388987f4f8db3c866c69e33e0b4c8b093fdf700e/setuptools-80.4.0.tar.gz"
    sha256 "5a78f61820bc088c8e4add52932ae6b8cf423da2aff268c23f813cfbb13b4006"
  end

  resource "webrtcvad-wheels" do
    url "https://files.pythonhosted.org/packages/28/ba/3a8ce2cff3eee72a39ed190e5f9dac792da1526909c97a11589590b21739/webrtcvad_wheels-2.0.14.tar.gz"
    sha256 "5f59c8e291c6ef102d9f39532982fbf26a52ce2de6328382e2654b0960fea397"
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
      config_file.write <<~INI
        [backup]
        folder = #{pkgvar}/backup
      INI
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

    (testpath/"config/config.ini").write <<~INI
      [backup]
      folder = #{testpath}/custom_backup
    INI

    port = free_port

    Open3.popen3(bin/"bazarr", "--no-update", "--config", testpath, "--port", port.to_s) do |_, _, stderr, wait_thr|
      Timeout.timeout(45) do
        stderr.each do |line|
          refute_match "ERROR", line unless line.match? "Error trying to get releases from Github"
          break if line.include? "BAZARR is started and waiting for requests on: http://0.0.0.0:#{port}"
        end
        assert_match "<title>Bazarr</title>", shell_output("curl --silent http://localhost:#{port}")
      end
    ensure
      Process.kill "TERM", wait_thr.pid
    end

    assert_path_exists (testpath/"config/config.ini.old")
    assert_includes (testpath/"config/config.yaml").read, "#{testpath}/custom_backup"
    assert_match "BAZARR is started and waiting for request", (testpath/"log/bazarr.log").read
  end
end
