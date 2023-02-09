class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/33/42/09d44ca8a6ee8eb9982e6e289bcc4523cbd8f2290decc3a07655c1a22bfd/nicotine-plus-3.2.8.tar.gz"
  sha256 "48e1bcda9483f3d2228f8c4ff6fe68f1b61898c354d54b1358726997b926b283"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11c8055c72c63005533bdd885725c718c4d6aea8bde08bdea26a8ec38ecd06d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11c8055c72c63005533bdd885725c718c4d6aea8bde08bdea26a8ec38ecd06d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11c8055c72c63005533bdd885725c718c4d6aea8bde08bdea26a8ec38ecd06d5"
    sha256 cellar: :any_skip_relocation, ventura:        "95a7c7afc6f11ded4c371e399742eca04623ac03da325bcf79c8a0abc9b60eea"
    sha256 cellar: :any_skip_relocation, monterey:       "95a7c7afc6f11ded4c371e399742eca04623ac03da325bcf79c8a0abc9b60eea"
    sha256 cellar: :any_skip_relocation, big_sur:        "95a7c7afc6f11ded4c371e399742eca04623ac03da325bcf79c8a0abc9b60eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "712f9afcae609467ad05974c0e63fad110a43676dc63bb6e73784ef5e3e71c8e"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

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
