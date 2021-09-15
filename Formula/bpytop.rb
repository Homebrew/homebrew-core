class Bpytop < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://github.com/aristocratos/bpytop/archive/v1.0.67.tar.gz"
  sha256 "e3f0267bd40a58016b5ac81ed6424f1c8d953b33a537546b22dd1a2b01b07a97"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2628a4b51b898319842f449e0e6ccc33eca3559b4a828cb72713cc7523c42e08"
    sha256 cellar: :any_skip_relocation, big_sur:       "9767462c51c491bf1b4e4b0b1098f75edded649990cce5e5813d73d415dac4e0"
    sha256 cellar: :any_skip_relocation, catalina:      "73f93ec6992cfa6aa5f5e5b77482ced3b3a94297f5976fc14f3773eaf59707ac"
    sha256 cellar: :any_skip_relocation, mojave:        "4c0fa73e1f3a1e947d4238804553d7e2b29339a15ce25ea4515be65480e5a9e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2e9a290e3973226449e28ea5a41e388a5bb9e3548a65c29837b00206e6e91dc"
  end

  depends_on "python@3.9"
  on_macos do
    depends_on "osx-cpu-temp"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
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
