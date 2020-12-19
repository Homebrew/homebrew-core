class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/5a/6b/ad2db94bb2763dac12ef714ba7adf00a50237ca016556d26b9747869c0ad/bpytop-1.0.51.tar.gz"
  sha256 "7256d17a3a705abeeba273b87fa88fd9815fd74bb2b8f07b870938da1ba9ad8a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2b1f3d2ed30ceb229ad0dd2cdb438b2f050291aa386e057d6edcda8550e060d1" => :big_sur
    sha256 "63678217e7a4aa2f9952c2dff52a02e3a07728e1010540a5b7a1fda71537c2ac" => :catalina
    sha256 "d2d8be76d473030d004f1ade5b386e6e02bb565493259dece438003d817f6553" => :mojave
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
