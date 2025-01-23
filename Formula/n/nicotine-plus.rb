class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/07/20/6fc7098083926c4930dd1f18e87a1d83ef4e943971cb96a0ac80a4371d88/nicotine_plus-3.3.7.tar.gz"
  sha256 "7b0bad2584261f61a0fccc19c7b898d3906f379280faf6a480544887ac3f1803"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af1f4ffd58ac45eb0d375df8ef5e39979c885cdbe426cd6488155bfe6b0dd90c"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.13"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  conflicts_with "httm", because: "both install `nicotine` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    # nicotine is a GUI app
    assert_match version.to_s, shell_output("#{bin}/nicotine --version")
  end
end
