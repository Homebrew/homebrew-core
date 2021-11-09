class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/ab/e9/964cb0b2eedd80c92f5172f1f8ae0443781a9d461c1372a3ce5762489593/isort-5.10.1.tar.gz"
  sha256 "e8443a5e7a020e9d7f97f1d7d9cd17c88bcb3bc7e218bf9cf5095fe550be2951"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e288997f03692918152f57ed4bbfe666956f151d0fa536a6f8c6781613f4bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a47154bfc16591b733dba25c447f9a66c5623f0d79ebcaf761579f2ce1abcb1"
    sha256 cellar: :any_skip_relocation, monterey:       "dc2e7a944b7bc2b517ff0605e1aa58787a36c583746b66ce3eedf540bb0d1970"
    sha256 cellar: :any_skip_relocation, big_sur:        "844debc7be1067c96394d2aca0d0b6168c6c7be985ee5410f39deeb0898e971b"
    sha256 cellar: :any_skip_relocation, catalina:       "89041c73f3da0300871ba0d2777ac7acbdcb6179cbd2e23e1729c9ca47658e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc8dfdb4094129b412849b7f1247dcca83de39c3f774349c9e3509d763678e92"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"isort_test.py").write <<~EOS
      from third_party import lib
      import os
    EOS
    system bin/"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath/"isort_test.py").read
  end
end
