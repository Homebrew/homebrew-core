class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/b0/f6/04590074b28cb8a1ffe6b85de17a21da5f7794a245ef1e0d471d003a22b0/bpytop-1.0.54.tar.gz"
  sha256 "a25665e71627a5ec918e6ecf4422bea1ba449069958f64c3879029cfb58a0ac1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f5fa3e246d5f0988ee1ec8fb875e01ed219217886dc0e04dfbfdd43ac4fcc6f" => :big_sur
    sha256 "2e08dbf3aacdb20f7edcf230e52ce0f1ec49f83a6cb9d4f08db996a9963d3fa6" => :arm64_big_sur
    sha256 "6a2e7f78fb787df2f0d42eae4fc409d8edee4754246ae18070060ce0ff9dd7cf" => :catalina
    sha256 "f87d06001f4544107fcdc2942f129480f26ffebdc56a64464cec25b5a1572bf7" => :mojave
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
