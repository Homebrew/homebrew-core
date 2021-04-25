class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/c1/fe/25709a8103a6e2d0fc7dc79d919f541156c2c1a758ed5231965c3433588d/bpytop-1.0.64.tar.gz"
  sha256 "758fa894d6147bbdaba51b7bd1c5bf878b7f742c59ac10c1bfac5c974e2ca20a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea5b97c65402aba37adfd6d227b5a6232249e1897bada76a7d2b63e2665481bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "332ab74636f4b41b83cf717eaa55a33405ee6de585a38c1e20b4e8e7d60baf6c"
    sha256 cellar: :any_skip_relocation, catalina:      "ecacc9a44eba5e190d6fcc835c5a2d751e76489472b23d3f4e21d2eea44bdc88"
    sha256 cellar: :any_skip_relocation, mojave:        "77e1fd7926e3187c90d5456e9f990f1530b17f518272cce1bda972101984a69d"
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
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
