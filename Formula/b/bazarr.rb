require "language/node"

class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://github.com/morpheus65535/bazarr/releases/download/v1.4.3/bazarr.zip"
  sha256 "b664dd9947d1051941d788ee371528eb945efbd6a05015f40414ae36ede9482d"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e861c369e72abb6c6d001e094977d9cabb800a78364ecbfd0a5f8da838397008"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "539fd0d60bf1bc1cf5a988954f6196d358c77f7df2c2f34d22e84243e97a8d28"
    sha256 cellar: :any,                 arm64_monterey: "5ab40f896cd2e8cc05c6b0c8b444af74c79033f5434042c2bbeed3626ad0410c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b9965a3c6b62ff450104bcfd4b0d68aec535a4a7a57fe9a43febb3efe225380"
    sha256 cellar: :any_skip_relocation, ventura:        "721eedf56183659946b51032538f3a22ff35eb7cf02c8b39c71138a1f476c5b5"
    sha256 cellar: :any,                 monterey:       "ed2a438a8615a04912095b411455e2a0640cca7b61f926af75ccb7e33a17004b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af558a6bdc2325cb21741ef5bd6f4aa3570151ac17f6ea6ec2984d3cac0396cc"
  end

  depends_on "node" => :build
  depends_on "ffmpeg"
  depends_on "gcc"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "unar"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
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
    end

    assert_predicate (testpath/"config/config.ini.old"), :exist?
    new_config_file = testpath/"config/config.yaml"
    assert_includes File.read(new_config_file), "#{testpath}/custom_backup"
    bazarr_log = testpath/"log/bazarr.log"
    assert_match "BAZARR is started and waiting for request", bazarr_log.read
  end
end
