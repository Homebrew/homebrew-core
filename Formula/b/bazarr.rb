require "language/node"

class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://github.com/morpheus65535/bazarr/releases/download/v1.4.1/bazarr.zip"
  sha256 "aa43afa1d387795fa3a3ff9ce918951268e8ad717e3c82780be4bdfe10c15bdf"
  license "GPL-3.0-or-later"
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8249cb3e493dd13381009fd6fb5e429a365a8c2572d4aa80fef4572d05dcd957"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a91f45a7d209933d157cc9d330e0956b4c6484160723a74dd56ae05222f1b3db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6484b1b9357ba6adb0616b035b3f37563a1699a2110c1c0ccdc3675026a125e"
    sha256 cellar: :any_skip_relocation, sonoma:         "705120a0b15b44a9bf7b7836a2f62a099d5dfc9ec56624d78659d8007c60202d"
    sha256 cellar: :any_skip_relocation, ventura:        "8ebb407abfa3dd7826599094d73ac372f51fc0db443350635d29e00bc817e057"
    sha256 cellar: :any_skip_relocation, monterey:       "28c0f9410468050138b71cbf8e7e40ff2334c8ee863b16abff69e8979766b6a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6d6919ca6172c338baf5fe23ddb0e815b54deb93d897b3625121ae2ba63073d"
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

    assert_predicate (testpath/"config/config.ini.old"), :exist?
    new_config_file = testpath/"config/config.yaml"
    assert_includes File.read(new_config_file), "#{testpath}/custom_backup"
    bazarr_log = testpath/"log/bazarr.log"
    assert_match "BAZARR is started and waiting for request", bazarr_log.read
  end
end
