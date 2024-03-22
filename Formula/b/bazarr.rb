require "language/node"

class Bazarr < Formula
  include Language::Python::Virtualenv

  desc "Companion to Sonarr and Radarr for managing and downloading subtitles"
  homepage "https://www.bazarr.media"
  url "https://github.com/morpheus65535/bazarr/releases/download/v1.4.2/bazarr.zip"
  sha256 "d4ea9b0b2426037dd9bf2084d75652c95c04832ca6d18d045faab1de0ef59674"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/morpheus65535/bazarr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc9a05033e30a60347e21a9f0385e0d0bff9ba02afba76bd7fd654ef70b63406"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4742b87418de51338af2f6de6fc8d0b9d45bebb12c8b9afb44eb28302f7bfd5"
    sha256 cellar: :any,                 arm64_monterey: "1a3cdc732a58ca24c213291e2c837d1b1ca2127e00dfd5ee08f2c47403e54c6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7706347932692a28dfec3ae099a7918b19afec01e228b54fa8b89dc1e64871bf"
    sha256 cellar: :any_skip_relocation, ventura:        "f6bc753d48be7d4cffdcb856e1d3eb90a63752258f25a1bd18b357551fc481ba"
    sha256 cellar: :any,                 monterey:       "a4845d308bf615e39e7376d9674349c5a061db07a4ed13fd1f812d8442eaff83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46df17881487050ed8fb6412044d892b1a08fff3cc53d354397050bdb5d42ad6"
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
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
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
      Process.wait wait_thr.pid
    end

    assert_predicate (testpath/"config/config.ini.old"), :exist?
    new_config_file = testpath/"config/config.yaml"
    assert_includes File.read(new_config_file), "#{testpath}/custom_backup"
    bazarr_log = testpath/"log/bazarr.log"
    assert_match "BAZARR is started and waiting for request", bazarr_log.read
  end
end
