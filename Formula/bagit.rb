class Bagit < Formula
  include Language::Python::Virtualenv

  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://libraryofcongress.github.io/bagit-python/"
  url "https://files.pythonhosted.org/packages/ee/11/7a7fa81c0d43fb4d449d418eba57fc6c77959754c5c2259a215152810555/bagit-1.7.0.tar.gz"
  sha256 "f248a3dad06fd3e5d329217baace6ade79d106579696b13e2c0bbc583101ded4"
  license "CC0-1.0"
  revision 1
  version_scheme 1
  head "https://github.com/LibraryOfCongress/bagit-python.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "86cf43159c0f34293039285a88480edf09369896665a75a075b69c2a0de57d38" => :big_sur
    sha256 "77e0cf9a2484eed1d2822a20df071c490bcb3676fe554edd1ab71e44defa0256" => :arm64_big_sur
    sha256 "193388b8a93aa1d52e3cf8acd5da0d3d6dc0e71fbf598ea654b620ba377a7517" => :catalina
    sha256 "f1a211e58d9945524ab5aa5cc62ee180e553b8fde90d969fda952cf629e21c99" => :mojave
    sha256 "e3f52f281e13d9d333d4425b603c609f07e502b2ad8525dcf6b633da0e4a5721" => :high_sierra
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
