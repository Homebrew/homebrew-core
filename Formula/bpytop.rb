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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b82bd9c9b4e1eaa8ca06c1de80a791b66c7b250dd50d062326db0b53390da793"
    sha256 cellar: :any_skip_relocation, big_sur:       "7476adb29b33fadcbc402edc7e19a511af60ee95870785342703c4c103d2fe84"
    sha256 cellar: :any_skip_relocation, catalina:      "b292c129d613342fb9bf3d8a8ff63578a4c4cd6c928bb0a2a205f3f4e980a270"
    sha256 cellar: :any_skip_relocation, mojave:        "e4e3977fa3294c1cb76b57c968b02ffe6b511ce91799da78c1872ca22431633f"
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
