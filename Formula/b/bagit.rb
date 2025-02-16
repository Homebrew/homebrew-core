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

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "c52968f9d307a0525271426a777174e9c488c3a062ea6756a68fbf671ab320d3"
  end

  depends_on "python@3.13"

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
    system bin/"bagit.py", "--source-organization", "Library of Congress", testpath.to_s
    assert_path_exists testpath/"bag-info.txt"
    assert_path_exists testpath/"bagit.txt"
    assert_match "Bag-Software-Agent: bagit.py", File.read("bag-info.txt")
    assert_match "BagIt-Version: 0.97", File.read("bagit.txt")

    assert_match version.to_s, shell_output("#{bin}/bagit.py --version")
  end
end
