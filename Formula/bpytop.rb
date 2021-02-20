class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/39/64/a72dd8d462de428f36d1f4a17f21ff5f71d382eb92dc1ddbb6b98e6ebb2e/bpytop-1.0.62.tar.gz"
  sha256 "9a408ffe6575c4e20621215e532b206fe6b6d2e7e4bd053ab4b4906e6d7ba909"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4addc771bc3230557490a97705b444944c70c75e1fc8ee898a0e2a4ed3f44fcc"
    sha256 cellar: :any_skip_relocation, big_sur:       "195bb1e8cac09870997c2059f17854bd5fdb3974460a0f411549ccb2a57ad0ed"
    sha256 cellar: :any_skip_relocation, catalina:      "5cb02f1cccf612bab2dcf5039b1ecd9c914662cf8628676b72185059bac77ceb"
    sha256 cellar: :any_skip_relocation, mojave:        "c85b26479ee5ae5322eed3c82fe7cf1f625ed5d0f7de36847f2331a33682f3f4"
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
    assert_not_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
