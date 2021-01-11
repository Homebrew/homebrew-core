class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/c0/7b/8a81267ab04c286e2f7da3b1db488f1e2af917937223589281af87a05308/bpytop-1.0.59.tar.gz"
  sha256 "bfa578e770fa8ac30e9efde23724d305c226989c29e554e8a56124ec28510124"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7bda6f0e5608777227250c8e4befea76eb5ad291145130f139fd33a81f069ab" => :big_sur
    sha256 "fa45863a58eefee5501f5126e3796ef8029118dccd95b320375b5222c77839c5" => :arm64_big_sur
    sha256 "3f646818bc118548e899ce67b6164c0becabad1a5e6678f87ab49b9bc80b0c5f" => :catalina
    sha256 "e5f468f45ea40c94d968e543f754355a442cdc4f8eab9c10f7d0a51bbcc0b475" => :mojave
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
