class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/7c/b9/883c0dbe7476b591852ac56c306b014574615d34cb95b8c9b2f6497355b1/nicotine_plus-3.3.11.tar.gz"
  sha256 "e27f562e3ba835116483bebf906aef5dab4cbe87b338e4511fa10ad6db14becc"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18ab9747adb86fb6a8ef462df2b7f476be9d47c70292974ea90ea9e4c706aa00"
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
