class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/d7/1a/a43e2f3e6928fa210b03758a2a397898aa7381c480e3bfac121707d233cc/isort-5.11.1.tar.gz"
  sha256 "7c5bd998504826b6f1e6f2f98b533976b066baba29b8bae83fdeefd0b89c6b70"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cf6782c45d4a993b98d32b08c838c4e0d892fe630ec8147a3b93c0daf8d9cb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f12530193537a9ba59ad1faf710ae95b413b81ea010afb7439d745915315ab0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b627194f06da8b15b0442b427253444a2fefccf0128b8401ca1c4a6de0527dd"
    sha256 cellar: :any_skip_relocation, ventura:        "daa1e1eb60c8300cde95f6826247b23700a5b8bfa1f8b08ad9951bf26cd31501"
    sha256 cellar: :any_skip_relocation, monterey:       "3948c1cca67ee7ba7f0624fd6a937b1b3d9c549e888236abd280d4187e35ff76"
    sha256 cellar: :any_skip_relocation, big_sur:        "f27d9bcf36b244f96c09fbf72e619f7622cf06bccb94923a7ae516a6f42bedf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d93aa4fc778454ebd10e07b6c0d1ed47a0f6b9e748f73f33ac60ddebdb7abb0d"
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
