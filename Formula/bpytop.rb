class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/8d/6a/506756ced98883e2016681da1719156cb9a41a456cd0b2e4449c2b734e0f/bpytop-1.0.56.tar.gz"
  sha256 "ac8dd7f69ff590ec22049df293899bf9e6eea297e8ccf5c84e849158f9dc2c2f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4943d1c9e6165fe305b3e47cfb5e19e434f6442a1278961ba4b6942dff90d749" => :big_sur
    sha256 "7c595aea2eeeb7805a69b03f276a3befeb511ae13091d91b2f6f7533a7e8139b" => :arm64_big_sur
    sha256 "137a231daf1cf1e49e611f905144473052b36f4d37b7bdfee8a43cd7c62a3fa5" => :catalina
    sha256 "57fd02b5832781fd11f1d701f5c8fe698a8c7e1ffdc4621bfe0a7136f40439f3" => :mojave
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
