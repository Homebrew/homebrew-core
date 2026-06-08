class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/bb/91/b7d2f353828d1bc57bb43cfe9006b0fde4d6ffe1458d5045c58f567ed33a/nicotine_plus-3.3.10.tar.gz"
  sha256 "a4f4cbfade9cf48af10ecb7bde1eac8b5c1b0194f9cd01c814349ddba453dd12"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "80edf82b7afa3a964e69c28edab21a4a588144096efaa10f555b567b1c0bfa3e"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "py3cairo" => :no_linkage
  depends_on "pygobject3" => :no_linkage
  depends_on "python@3.14"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  conflicts_with "httm", because: "both install `nicotine` binaries"

  pypi_packages exclude_packages: %w[pycairo pygobject]

  def install
    virtualenv_install_with_resources
  end

  test do
    # nicotine is a GUI app
    assert_match version.to_s, shell_output("#{bin}/nicotine --version")
  end
end
