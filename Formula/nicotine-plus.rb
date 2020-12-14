class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.org/"
  url "https://github.com/Nicotine-Plus/nicotine-plus/archive/2.2.2.tar.gz"
  sha256 "a2734f11beb7ec4e32d1c8270b7328721b841830b22aed2db3c4acf2b66791bb"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    cellar :any
    sha256 "bdba841698f194d00a44586bef26acefb8371f681d8ab31dd2f6fb1cdaae2705" => :big_sur
    sha256 "dc9c56ceb84625f2c6cae5f9cdc291fba3d1d3e177c1de99d3b7446c766f3ac0" => :catalina
    sha256 "c2e1d03e2eed1a033031a9b9617cf82cb351f626bdfc62f4d7cafe3892544839" => :mojave
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nicotine -v")
    pid = fork do
      exec bin/"nicotine", "-s"
    end
    sleep 3
    Process.kill("TERM", pid)
  end
end
