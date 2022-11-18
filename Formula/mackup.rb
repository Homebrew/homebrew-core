class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/2d/f3/44d0c845a297a15c8a53c69bad2583ba7c18e005c774ed3c8d96285276d0/mackup-0.8.36.tar.gz"
  sha256 "052d8a46b918d8711fd50f103ad905403466feed6bd3d6676fa9805e8c13661b"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f92f02b53047b2864afddaac52227cef58b9f3b8a79853644a163ff24c755b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f92f02b53047b2864afddaac52227cef58b9f3b8a79853644a163ff24c755b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f92f02b53047b2864afddaac52227cef58b9f3b8a79853644a163ff24c755b4"
    sha256 cellar: :any_skip_relocation, ventura:        "7b5262d630bd84750ef2ad8a23d7e64a2ca538337a74fe51729da07c614efb00"
    sha256 cellar: :any_skip_relocation, monterey:       "7b5262d630bd84750ef2ad8a23d7e64a2ca538337a74fe51729da07c614efb00"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b5262d630bd84750ef2ad8a23d7e64a2ca538337a74fe51729da07c614efb00"
    sha256 cellar: :any_skip_relocation, catalina:       "7b5262d630bd84750ef2ad8a23d7e64a2ca538337a74fe51729da07c614efb00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9756b171cec55ef691222e4903182ac25593fa13c5e93be68505339682380c4c"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
