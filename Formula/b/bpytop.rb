class Bpytop < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://github.com/aristocratos/bpytop/archive/v1.0.68.tar.gz"
  sha256 "3a936f8899efb66246e82bbcab33249bf94aabcefbe410e56f045a1ce3c9949f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "becab23db91f8307110f48affbf8fbb7cd563687a3b2396cb8ebd6c3b495f22b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e1e60fabfc1c12c865fce8effc365fcf76650655004d63099c3799396785034"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de2bb84abd2e704d144218659c3e9c188304b170e9dd6187b22138158182c15c"
    sha256 cellar: :any_skip_relocation, ventura:        "df1e0d8d3777948aece75453634ddb2746c76a1795ad1fcc452cf4119604842f"
    sha256 cellar: :any_skip_relocation, monterey:       "0b157751f5c2a3d8e7820356d2d49e29587d98ea93c82533605ca9429c4c1e36"
    sha256 cellar: :any_skip_relocation, big_sur:        "f14bd5dfed41695186fce259e9c974298da36cfbd47b9598af539c0fda697d9c"
    sha256 cellar: :any_skip_relocation, catalina:       "7ec48aedfe22ed4f1eef9a79bf824f47c8dc31729ee66546c7edd2e985c0b6c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdb97df09c1d785d498ff04c87f219d0b5cfebc5cde09cb0039f879198746cc7"
  end

  depends_on "python@3.11"

  on_macos do
    depends_on "osx-cpu-temp"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/de/eb/1c01a34c86ee3b058c556e407ce5b07cb7d186ebe47b3e69d6f152ca5cc5/psutil-5.9.3.tar.gz"
    sha256 "7ccfcdfea4fc4b0a02ca2c31de7fcd186beb9cff8207800e14ab66f79c773af6"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "themes"

    # Replace shebang with virtualenv python
    rw_info = python_shebang_rewrite_info("#{libexec}/bin/python")
    rewrite_shebang rw_info, bin/"bpytop"
  end

  test do
    config = (testpath/".config/bpytop")
    mkdir config/"themes"
    (config/"bpytop.conf").write <<~EOS
      #? Config file for bpytop v. #{version}

      update_ms=2000
      log_level=DEBUG
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/bpytop")
    r.winsize = [80, 130]
    sleep 5
    w.write "\cC"

    log = (config/"error.log").read
    assert_match "bpytop version #{version} started with pid #{pid}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
