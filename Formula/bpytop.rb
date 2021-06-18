class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/e9/1a/fd710c94c0888b139681d132f60608c657ff265b50b9312fd3cba35e08dc/bpytop-1.0.67.tar.gz"
  sha256 "8b338e3627fa6e991e836bee61ef38988f6a7a3a37dc05c757a92ba4378f95bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b82bd9c9b4e1eaa8ca06c1de80a791b66c7b250dd50d062326db0b53390da793"
    sha256 cellar: :any_skip_relocation, big_sur:       "7476adb29b33fadcbc402edc7e19a511af60ee95870785342703c4c103d2fe84"
    sha256 cellar: :any_skip_relocation, catalina:      "b292c129d613342fb9bf3d8a8ff63578a4c4cd6c928bb0a2a205f3f4e980a270"
    sha256 cellar: :any_skip_relocation, mojave:        "e4e3977fa3294c1cb76b57c968b02ffe6b511ce91799da78c1872ca22431633f"
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
    pkgshare.install "themes"
  end

  test do
    config = (testpath/".config/bpytop")
    mkdir config/"themes"
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
