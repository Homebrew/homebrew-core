class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/24/17/01ec1306d54dc8d2e1aaecc135bde2e587a3ad5c50fe9b8ed982d1a11fad/bpytop-1.0.55.tar.gz"
  sha256 "8632399d1fad4c7910e238c4c5646f1a186b5d04927fad1d262a5817b3bcf282"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "783838028a580648e33483b04296340f0a4fe85f0d286e81fe076da9362ee627" => :big_sur
    sha256 "45e6e01a34c709b1f03675afef5a41b5dc8ee91a29b104763d2c76b7f2dcafa6" => :arm64_big_sur
    sha256 "9befa70b5bf6084f741666670f1abc4a148640d0a41c09fd2b3f45fa176cd409" => :catalina
    sha256 "c0ab2a72db7e51121fbf6658c37443a54cdc42e93ddd1254b95a52207fdbc99c" => :mojave
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
