class Bagit < Formula
  include Language::Python::Virtualenv

  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://libraryofcongress.github.io/bagit-python/"
  url "https://files.pythonhosted.org/packages/e5/99/927b704237a1286f1022ea02a2fdfd82d5567cfbca97a4c343e2de7e37c4/bagit-1.8.1.tar.gz"
  sha256 "37df1330d2e8640c8dee8ab6d0073ac701f0614d25f5252f9e05263409cee60c"
  license "CC0-1.0"
  version_scheme 1
  head "https://github.com/LibraryOfCongress/bagit-python.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/project/bagit/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77e0cf9a2484eed1d2822a20df071c490bcb3676fe554edd1ab71e44defa0256"
    sha256 cellar: :any_skip_relocation, big_sur:       "86cf43159c0f34293039285a88480edf09369896665a75a075b69c2a0de57d38"
    sha256 cellar: :any_skip_relocation, catalina:      "193388b8a93aa1d52e3cf8acd5da0d3d6dc0e71fbf598ea654b620ba377a7517"
    sha256 cellar: :any_skip_relocation, mojave:        "f1a211e58d9945524ab5aa5cc62ee180e553b8fde90d969fda952cf629e21c99"
    sha256 cellar: :any_skip_relocation, high_sierra:   "e3f52f281e13d9d333d4425b603c609f07e502b2ad8525dcf6b633da0e4a5721"
  end

  depends_on "python@3.9"

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
