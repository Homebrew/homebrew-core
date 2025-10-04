class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/1e/82/fa43935523efdfcce6abbae9da7f372b627b27142c3419fcf13bf5b0c397/isort-6.1.0.tar.gz"
  sha256 "9b8f96a14cfee0677e78e941ff62f03769a06d412aabb9e2a90487b3b7e8d481"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a93182da6b78ae09ff947818e70c9b4442011c62e47c35984baa131cccc4207c"
  end

  depends_on "python@3.13"

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
