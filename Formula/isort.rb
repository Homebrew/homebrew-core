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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5d80e1cffa56c250a8243033e2e6585f26fdc221832ef8de29605b1a6faa0d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daeeb039c407bf866eb0434385719cf8b1339aae5cf68be775634ba9731ed825"
    sha256 cellar: :any_skip_relocation, monterey:       "9e7b35776d714719ba5cc4ccf3d1414d85f867e9df737318e189362e006e3fdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b51b857b09c1b94786bbc617d1f98b9415392cf01791562598b6e7415a932f9"
    sha256 cellar: :any_skip_relocation, catalina:       "ea516d354aeaa438e9622b444d163a6b61ed0c7784c421117b0fd611010472c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf4067868dd02d11c067e12acd8091a7aadb41c234e0250f46824328e3f1598"
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
