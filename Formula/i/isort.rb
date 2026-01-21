class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/63/53/4f3c058e3bace40282876f9b553343376ee687f3c35a525dc79dbd450f88/isort-7.0.0.tar.gz"
  sha256 "5513527951aadb3ac4292a41a16cbc50dd1642432f5e8c20057d414bdafb4187"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8a1f07df8891c8812977c1469578923a4129f2afaa12a9533fcd2f585a1fe1d"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"isort_test.py").write <<~PYTHON
      from third_party import lib
      import os
    PYTHON
    system bin/"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath/"isort_test.py").read
  end
end
