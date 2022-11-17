class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/ab/e9/964cb0b2eedd80c92f5172f1f8ae0443781a9d461c1372a3ce5762489593/isort-5.10.1.tar.gz"
  sha256 "e8443a5e7a020e9d7f97f1d7d9cd17c88bcb3bc7e218bf9cf5095fe550be2951"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdad61776c881cc14bb973945fe886563e181f2489a7ca0417ca21d4ba9cc326"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15cfbe803b3c78287b20dec69d4e818faa283c3c7ee5985fe6ce813fbd942100"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7805c1a3542fad49e9c94df68de2fa0ae95f8a78205a3a30e9267c9859896b38"
    sha256 cellar: :any_skip_relocation, ventura:        "a4f1d5122cb8ccff3936e75ef9d490b0026d31190a3a0392a4e59bb516fe7838"
    sha256 cellar: :any_skip_relocation, monterey:       "a158bd42648bb4fdd40986bad0ffc1031a7ccaa02c54beb7a1c16e3ae72f7311"
    sha256 cellar: :any_skip_relocation, big_sur:        "08c4c1de176b993c175757bd8c880b89bbb3c74908911a4b7e86e62677d82bc8"
    sha256 cellar: :any_skip_relocation, catalina:       "95fb698784bb04bac9e8cc71d4e1842cc8ca1a31941e008eee2d9ed5b4e37451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ac75e1dfba24d96a8473e59412aebad6305757721955f652275a4fe7175135d"
  end

  depends_on "python@3.11"

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
