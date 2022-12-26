require "language/node"

class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://github.com/morpheus65535/bazarr/releases/download/v1.1.3/bazarr.zip"
  sha256 "8ede84f95b43ec974f20975606456b43288d7d3eefc52633e245eb15001da571"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "191075c049ec2090616c698d31cc0560535871154b795cb82caddfd9d6e4f6dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9eb2e9016fc21e59ef8b006cba0b9e7a55ea2e84b374c0fdf4cf61ae5daf147"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f3947958f831acef279c21ed4f0c2d3c80393f5d72296f2b7f3c9c35ab93b00"
    sha256 cellar: :any_skip_relocation, ventura:        "cf2f8e9b53ea8f2dfcc1f6cd50f9654255e507dd0dd9258e5d900ba2089e34c3"
    sha256 cellar: :any_skip_relocation, monterey:       "140d97b5cb92f3c32cfe1396bfbad2b30eafba6a8cdd705d13ecc2dea44a6d64"
    sha256 cellar: :any_skip_relocation, big_sur:        "053078f4502732e1641d395d608fe5705cccaa451db325a56365ddd4da837ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4251de38404c2bdc75ad5670e2833d0676a6c919eac9dafb5ea0876a08bf3818"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "gcc"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "unar"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "webrtcvad-wheels" do
    url "https://files.pythonhosted.org/packages/59/d9/17fe64f981a2d33c6e95e115c29e8b6bd036c2a0f90323585f1af639d5fc/webrtcvad-wheels-2.0.11.post1.tar.gz"
    sha256 "aa1f749b5ea5ce209df9bdef7be9f4844007e630ac87ab9dbc25dda73fd5d2b7"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages("python3.11")
    venv = virtualenv_create(libexec, "python3.11")

    venv.pip_install resources

    if build.head?
      # Build front-end.
      cd buildpath/"frontend" do
        system "npm", "install", *Language::Node.local_npm_install_args
        system "npm", "run", "build"
      end
    end

    # Stop program from automatically downloading its own binaries.
    binaries_file = buildpath/"bazarr/utilities/binaries.json"
    rm binaries_file
    binaries_file.write "[]"

    libexec.install Dir["*"]
    (bin/"bazarr").write_env_script libexec/"bin/python", "#{libexec}/bazarr.py",
      NO_UPDATE:  "1",
      PATH:       "#{Formula["ffmpeg"].opt_bin}:#{HOMEBREW_PREFIX/"bin"}:$PATH",
      PYTHONPATH: ENV["PYTHONPATH"]

    (libexec/"data").install_symlink pkgetc => "config"
  end

  def post_install
    pkgetc.mkpath
  end

  plist_options startup: true
  service do
    run opt_bin/"bazarr"
    keep_alive true
    log_path var/"log/bazarr.log"
    error_log_path var/"log/bazarr.log"
  end

  test do
    require "open3"
    require "timeout"

    system "#{bin}/bazarr", "--help"

    port = free_port

    Open3.popen3("#{bin}/bazarr", "--config", testpath, "-p", port.to_s) do |_, _, stderr, wait_thr|
      Timeout.timeout(30) do
        stderr.each do |line|
          refute_match "ERROR", line
          break if line.include? "BAZARR is started and waiting for request on http://0.0.0.0:#{port}"
        end
        assert_match "<title>Bazarr</title>", shell_output("curl --silent http://localhost:#{port}")
      end
    ensure
      Process.kill "TERM", wait_thr.pid
      Process.wait wait_thr.pid
    end
  end
end
