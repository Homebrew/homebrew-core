class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/1e/d5/35536e21b33b881d2cd13c79f6404691a23268eafad00300214788b3ca2c/nicotine-plus-2.2.2.tar.gz"
  sha256 "6913aabd98cb841d6c05213f8004300c2e90d9afdaf5aa081269b272494762f5"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "c6b26f5e472d343bd5f6190af50d15326df5d4b249c973bb997de195d7af26fa" => :big_sur
    sha256 "284ab0e4d1fdfc9bab0c6478ed2c354c1f047f39d0658f1b073dd2a9a37b84ce" => :arm64_big_sur
    sha256 "f03e6e761f7a8062d506738b544762e89a020f626d8ba154b7c838a44dbd5af4" => :catalina
    sha256 "52431db05bd1e9c96594a8e1168c9e3645c53f582df85841d5e04ddf5b8bc1dd" => :mojave
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
