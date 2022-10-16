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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e7502fd86287ae876a205a97f46324d76b5866decce960cdd46638d567b1797"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "056148533d39abdebd1cd5112778a2cfa97a9a4f55fcc3c5f49df41c1a28f049"
    sha256 cellar: :any_skip_relocation, monterey:       "998fedfaacdcff31fdf5d9c91aef1bf01a006b1c1f5fad219f37e9ea56346f20"
    sha256 cellar: :any_skip_relocation, big_sur:        "17050d67fdcbff24d19571e305bcf3bdd86edf1d05e9989e97ba48ae4db0c68c"
    sha256 cellar: :any_skip_relocation, catalina:       "6283d6605df7f70ab72ba22c0f6694959beb38eedf0add8be20f281effaf0704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf2d80f9e08a9f27a0b3a9da0c39057b5a6d9d4fffd21211276446cea195dd2"
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
