class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/14/95/880671055bcd9d0fc1283b8937abab53e88e05d457b4822e29562e28d4ea/bpytop-1.0.53.tar.gz"
  sha256 "d08b8120444e7f35fe032b33495ca551b5890702130c45ad8a56c1fa978fc358"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ffb59aee70d89c9db96838f05d829eb91fffcfd1e39abf80874c94bab2f48fa" => :big_sur
    sha256 "7407ca444be9f8b7626b4a270af932fa79d26d34711d6b540df603ee7875a94e" => :arm64_big_sur
    sha256 "199055f9be0ec338a51d49b29fe3d45af387668b96e9d54d30fde06d935f5096" => :catalina
    sha256 "185cbc02e0275ff68cb0d0cf3cdc52ec0959bbce44716114a79c19de8f8b9a5a" => :mojave
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
