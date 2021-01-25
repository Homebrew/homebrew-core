class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/4a/68/af63843b898c9b8a6010147ec306aab21b4d8cb684087ce9c50a94f065e7/bpytop-1.0.61.tar.gz"
  sha256 "4bca4202ca986210250d25a182852c2fd48e46d0f51f8efc6266232377ceb2dc"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a50aaf97067280960a462596625be6af01098e6e23850aa546e29490f222c2a5" => :big_sur
    sha256 "86e301b52ef369a02e5beaf9e726a0da377f29759395485b52718a168a90ee14" => :arm64_big_sur
    sha256 "040c3f76fc5dc9df03b44eff4053d8edb74908447ea7081c06d0a913a9b600c8" => :catalina
    sha256 "0cfe29295f282bc25e4ce89139da7302ba33f981600af39e4da512af3da6f455" => :mojave
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
    virtualenv_install_with_resources
    pkgshare.install "bpytop-themes" => "themes"
  end

  test do
    config = (testpath/".config/bpytop")
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
    assert_not_match /ERROR:/, log
  ensure
    Process.kill("TERM", pid)
  end
end
