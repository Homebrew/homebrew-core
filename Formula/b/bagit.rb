class Bagit < Formula
  include Language::Python::Virtualenv

  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://libraryofcongress.github.io/bagit-python/"
  url "https://files.pythonhosted.org/packages/e5/99/927b704237a1286f1022ea02a2fdfd82d5567cfbca97a4c343e2de7e37c4/bagit-1.8.1.tar.gz"
  sha256 "37df1330d2e8640c8dee8ab6d0073ac701f0614d25f5252f9e05263409cee60c"
  license "CC0-1.0"
  revision 1
  version_scheme 1
  head "https://github.com/LibraryOfCongress/bagit-python.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/project/bagit/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ac616d791db078c99f2a91e28f4eb215fd66627b9a9851dca31a922c1671c4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90df11c3427ddb75f74a1e4f8fa8e8deaa6fa0b4aa8dbc81c77b584cd53f967c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bd392766f572fd2218bb6d06c9109c258d509b05b679c1f5860d302ade534b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f9521d057fbe09ee366946d12b385f14bcbe0f745a6a001becff9b884b5e4b2"
    sha256 cellar: :any_skip_relocation, ventura:        "b9a324e0a48ebd2d5d71c24b7e4330bf1107e90686e91a94ab22f761056e13ff"
    sha256 cellar: :any_skip_relocation, monterey:       "e0c52143378dd79f8b6a9cb6a411eb62d9d6f0a5c22528e6f8f4aec860572df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1958e3df0bbfe57f3d7a7d0d7903e1bd27eaddcf0172e9520f71ba1961aab4f7"
  end

  depends_on "python@3.12"

  # Replace pkg_resources with importlib
  # https://github.com/LibraryOfCongress/bagit-python/pull/170
  patch do
    url "https://github.com/LibraryOfCongress/bagit-python/commit/de842aad182c74de21d09d108050740affb94f2e.patch?full_index=1"
    sha256 "f7fab3dead0089f44e6e65930a267f6d69f2589845e9ea4c1d6bbb3847f5ff3a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/bagit.py", "--source-organization", "Library of Congress", testpath.to_s
    assert_predicate testpath/"bag-info.txt", :exist?
    assert_predicate testpath/"bagit.txt", :exist?
    assert_match "Bag-Software-Agent: bagit.py", File.read("bag-info.txt")
    assert_match "BagIt-Version: 0.97", File.read("bagit.txt")

    assert_match version.to_s, shell_output("#{bin}/bagit.py --version")
  end
end
