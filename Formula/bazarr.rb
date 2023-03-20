require "language/node"

class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://github.com/morpheus65535/bazarr/releases/download/v1.2.0/bazarr.zip"
  sha256 "ae5a61f0e9ff75cf57cb1f3f290ce9e2f5f8f706387ebd684ed044c9f561aec7"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a13018b8b4838c8830712c655fbc023eea8d9f98e68fca2c836d288fa550d78a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d681ee13685471c0051a67308c71f2dea7aeceeaa1c1e561b88850073fd31c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5097bb62643d9914af6b6e9a271f3171440f9e9d2bd0a52850f301dce27453d8"
    sha256 cellar: :any_skip_relocation, ventura:        "83612762dac966535acbc59668c8fa27c9c8dc6fc0034943914d87a4e61c256b"
    sha256 cellar: :any_skip_relocation, monterey:       "f63b775857626f4804cae68e1453dda76eac2dbd66719a4838875745617b0c7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0859ca0701846288d74d806671c1e810ec777639fd398cb6c12d8f7ea192e961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a7a33d244fc59636474775310393d84ca4d0c357776bc99a4178e89c87354f"
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
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
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

    config_file = pkgetc/"config.ini"
    unless config_file.exist?
      config_file.write <<~EOS
        [backup]
        folder = #{opt_libexec}/data/backup
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

    assert_includes File.read(config_file), "#{testpath}/custom_backup"
  end
end
