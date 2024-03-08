class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/65/c7/890d2e484b3149e268fa3ebc3024fe4947b9bc91123431c70064c1ed54fd/nicotine-plus-3.3.2.tar.gz"
  sha256 "aa76ac841c3959c9c58286a0114f67532df0abe708e7a344ed8a9b3fc7ea351d"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "342a99092449af8d0a7fd7463372da38a63dc0f946686225d7dc65306bdf8353"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "157cd89f2e36da8a677a4084a94a1a873917645e45da2735f38489b32fc3b02f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ac2c9bc873c0fe3499909f1f9cca8a8e29f74bcba23f0fa0dd5ae02255b9943"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f2f30fc855beded07489d8f5468a1ccddf4b3deeab96ec50ff48ceb114edc56"
    sha256 cellar: :any_skip_relocation, ventura:        "c0944973adf40bc817dabf0023720c14867ea8ed706fabb49bb0e9afd70a981c"
    sha256 cellar: :any_skip_relocation, monterey:       "7f403a8f5fa4bdaa2865af1f56db80f8d5c6e527d8e0f245190a398cb44dcec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58cf3a47be14f16b677f34e8c38dae5bf3c82fc07c433e63147ae194e666dd42"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python-gdbm@3.12"
  depends_on "python@3.12"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # nicotine is a GUI app
    assert_match version.to_s, shell_output("#{bin}/nicotine --version")
  end
end
