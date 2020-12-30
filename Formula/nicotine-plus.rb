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
    rebuild 1
    sha256 "ef928b9b97833d14fc88287baeae60b18150466695061e3262d75bfaa5ff6930" => :big_sur
    sha256 "1f41e8015df019b8a56261867ba8cb11c313137459fc0c7350f0c70d5dbf5f75" => :catalina
    sha256 "8b0995596b1ce4de0a67dba2363b9dbee6a25761d2e26bf94e893cff262c4c81" => :mojave
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
