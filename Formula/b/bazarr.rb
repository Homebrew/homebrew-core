require "language/node"

class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://github.com/morpheus65535/bazarr/releases/download/v1.3.1/bazarr.zip"
  sha256 "02150caef9d9a28d1731f27a17d062e260b4864e53dc49103d7fece2d1d67227"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f8110d8fa7ac2da9c1ff3ec183e3a1d53fe2a05d092c33bb2533406802cf014"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3094952807be577cd5547fac535060d69c6f24c0a6323d1500216a57b876fd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5411e167b6577349e10d72bd1b713a6a8c2e3d669ed5d63fa6fe1520aeb66b7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "55c304fa19b2a0c37ec161330b5b29499514da7ef3dfbfed5aafa9bfbd591a24"
    sha256 cellar: :any_skip_relocation, ventura:        "b67dee5f86d031727a547dceebd80e84e180243802addaf2a83e381385e20401"
    sha256 cellar: :any_skip_relocation, monterey:       "87bbe837214e2f6d7e5a85ca1e314eabfa66703944d4d5a94cdc509a951fb7a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d28f197321bdcb049bec199c1190d080eba53cb27b0193112f748821ce5c918a"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "gcc"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python-lxml"
  depends_on "python@3.11"
  depends_on "unar"

  uses_from_macos "zlib"

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

    system "#{bin}/bazarr", "--help"

    config_file = testpath/"config/config.ini"
    config_file.write <<~EOS
      [backup]
      folder = #{testpath}/custom_backup
    EOS

    port = free_port

    Open3.popen3("#{bin}/bazarr", "--no-update", "--config", testpath, "-p", port.to_s) do |_, _, stderr, wait_thr|
      Timeout.timeout(30) do
        stderr.each do |line|
          refute_match "ERROR", line unless line.match? "Error trying to get releases from Github"
          break if line.include? "BAZARR is started and waiting for request on http://0.0.0.0:#{port}"
        end
        assert_match "<title>Bazarr</title>", shell_output("curl --silent http://localhost:#{port}")
      end
    ensure
      Process.kill "TERM", wait_thr.pid
      Process.wait wait_thr.pid
    end

    assert_includes File.read(config_file), "#{testpath}/custom_backup"
  end
end
