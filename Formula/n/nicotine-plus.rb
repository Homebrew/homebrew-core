class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/63/1c/73f765da20b5b7e3579f6099490a9c4ac93e7c6341f97cf51d53ea0df49f/nicotine_plus-3.3.4.tar.gz"
  sha256 "512bf4aea9b42d5f3d58e0c96ed90efc2af568f8d0a624bf957ffb5f84ab9b7c"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, ventura:        "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, monterey:       "ee66410a793440590408fc0524157aa98814d693bcf5173321eee17ed31bbf29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "603be73b6c65bf171d66df59924bb95264b65836e32a69e0a8c523dd5d076207"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"

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
