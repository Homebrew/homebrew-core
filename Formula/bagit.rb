class Bagit < Formula
  include Language::Python::Virtualenv

  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://libraryofcongress.github.io/bagit-python/"
  url "https://files.pythonhosted.org/packages/e5/99/927b704237a1286f1022ea02a2fdfd82d5567cfbca97a4c343e2de7e37c4/bagit-1.8.1.tar.gz"
  sha256 "37df1330d2e8640c8dee8ab6d0073ac701f0614d25f5252f9e05263409cee60c"
  license "CC0-1.0"
  version_scheme 1
  head "https://github.com/LibraryOfCongress/bagit-python.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/project/bagit/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "968ab8fef1c1378693bb911e8aebd42770ffb6cc02f51751008be4adec8ccd27"
    sha256 cellar: :any_skip_relocation, big_sur:       "62094bf88731c7b94940aa4e4653ca22cc041b25330e3423001eacaa88ab6ee9"
    sha256 cellar: :any_skip_relocation, catalina:      "8cb401bf3f5d03dd8ec84f47fb9bbebff28a0a5be96f1aeb4ee95530ec2b29b2"
    sha256 cellar: :any_skip_relocation, mojave:        "4fefca46d83bb674b3969080548a4b8028db0d3aa7225d83cb4d13bc4602e6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f04c2f68abc63b374410d0414544df8fb304d77e2c6c3624554f48c1c8bac5e9"
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
