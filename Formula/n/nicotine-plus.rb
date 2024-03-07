class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/65/c7/890d2e484b3149e268fa3ebc3024fe4947b9bc91123431c70064c1ed54fd/nicotine-plus-3.3.2.tar.gz"
  sha256 "aa76ac841c3959c9c58286a0114f67532df0abe708e7a344ed8a9b3fc7ea351d"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5565fe37bf69ffd2fae40f60264bad93d78d38514970992e4e419b4fd3d93cd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "332cec3c9bc5097df8eec71592de7b306a1523df6a133b6ca74013111fe8c430"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81508c19a88029ce215135865bd25a7a7f99ac640d48bd4d6ba12beee2b8cdd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "5911076dbbdfd23d02055f2eeb6312b9f2a504534c091f31cbf79f55fca2631a"
    sha256 cellar: :any_skip_relocation, ventura:        "af4b07dde9b61feb8ac719bac9d7bf1e98982ccf8c3d37e42816d4bf9c6d66b5"
    sha256 cellar: :any_skip_relocation, monterey:       "cb11d4103518471e4aa97d0d5236feaa22f9bd6c6846380d1e267411293f223e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78f419828edaf51c818c4458e30eab56f3009b3e2422a98145ea5b0a0af3bd0d"
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
