class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.org/"
  url "https://files.pythonhosted.org/packages/1e/d5/35536e21b33b881d2cd13c79f6404691a23268eafad00300214788b3ca2c/nicotine-plus-2.2.2.tar.gz"
  sha256 "6913aabd98cb841d6c05213f8004300c2e90d9afdaf5aa081269b272494762f5"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bb57d96d376930c48f6c66f47c2dde3f813b65b106870fe1b0a56cc8f3039145" => :big_sur
    sha256 "b8b27084c9f6aad79968494e1bac71a1690e2e01613857eda6b8ec1d723724b9" => :catalina
    sha256 "dd52da32c8394630c2f3264f27fe807c5a6cb059703ee490337d784ab7df9569" => :mojave
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
