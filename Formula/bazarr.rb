require "language/node"

class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://github.com/morpheus65535/bazarr/releases/download/v1.1.2/bazarr.zip"
  sha256 "7134917e7318032a0ea13cb4c31f2cc6ac92f76ccfe8666ef1a1f9851453c54e"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebe32b1145358d2cad23ac28811e0790dc5685f058bc9015ace97e060a1e74c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10ac64976c6e9b76370d2c374ccee845644cc741e19c3aca639accccc381db52"
    sha256 cellar: :any_skip_relocation, monterey:       "3adcf5f5cc03b9bd69671babd4ca01d03ba963c12073af3b1f7ef3c80c6891e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8995962b478ed84f0bd4685df9f144f9e90720e180733a9970dc99f3e6a01573"
    sha256 cellar: :any_skip_relocation, catalina:       "f915c272ba2ef71cc56f08bb0c5f30477bcb364e663a5286b6835ed6c3368bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6d9c38db158cea2fac353ec9bf8a4afa39ad86cc280d2b68490921cdd6de1c5"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "gcc"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.10"
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
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages("python3.10")
    venv = virtualenv_create(libexec, "python3.10")

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
    system "#{bin}/bazarr", "--help"

    port = free_port

    pid = fork do
      exec "#{bin}/bazarr", "--config", testpath, "-p", port.to_s
    end
    sleep 20

    begin
      assert_match "<title>Bazarr</title>", shell_output("curl --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
