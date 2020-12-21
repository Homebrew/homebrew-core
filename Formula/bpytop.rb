class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/71/67/a3004c075d9b6daf7a86c7bcd7092c968d0f6bab4746096306f2eaef27dc/bpytop-1.0.52.tar.gz"
  sha256 "51fe29abb01379a878c18d3cd3f57c95deeb509d65bfde21b0e4a0f0ab09c67b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "25598bf6682ca4d7e2d68209e597e5c48249784ab3b9ec69976da163223ff2bf" => :big_sur
    sha256 "28d5c7aef70e5cd3d68e93ef7d38a135cd628d0edd00e51b62d13a8484e31085" => :catalina
    sha256 "7b35974839fce21c2074f116b029795b8fe222a342bb801490fd01b28ecfd267" => :mojave
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
