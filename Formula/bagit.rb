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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "754fa656037ce4f1d5f6f53b2d8498565c5dcbd9423a9d8d5cce047f5bd4781b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "754fa656037ce4f1d5f6f53b2d8498565c5dcbd9423a9d8d5cce047f5bd4781b"
    sha256 cellar: :any_skip_relocation, monterey:       "dbbe53ea75bd1c6fcda5b26938ab79aa2676da5bcb434dbfc09fca3d4677f4a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbbe53ea75bd1c6fcda5b26938ab79aa2676da5bcb434dbfc09fca3d4677f4a5"
    sha256 cellar: :any_skip_relocation, catalina:       "dbbe53ea75bd1c6fcda5b26938ab79aa2676da5bcb434dbfc09fca3d4677f4a5"
    sha256 cellar: :any_skip_relocation, mojave:         "dbbe53ea75bd1c6fcda5b26938ab79aa2676da5bcb434dbfc09fca3d4677f4a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c460394f8bd13f972a848ac29a3dde16c9cdc2be167b3e34e9724c6b1fd6216d"
  end

  depends_on "python@3.10"

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
