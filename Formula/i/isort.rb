class Isort < Formula
  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/87/f9/c1eb8635a24e87ade2efce21e3ce8cd6b8630bb685ddc9cdaca1349b2eb5/isort-5.13.2.tar.gz"
  sha256 "48fdfcb9face5d58a4f6dde2e72a1fb8dcaf8ab26f95ab49fab84c2ddefb0109"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a909b4271e03b607f22adca9f91450d06782dbde8578506ab752dfa284cfa75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c191943e91ec93e8254a2063f08fa52a9694fc786ee4f93989cb76b29002c29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba1280febda448476d22f9e97eefdcbaa070963ec39d8dd08f65655320245e56"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e2c285cf5a2475917e401bfbafa9baeeb2f7e6501eab6a87ced07d815081c90"
    sha256 cellar: :any_skip_relocation, ventura:        "a27922320d9854b8791828a47a496cb676a2f61ae9cfde231b1c533b658c047d"
    sha256 cellar: :any_skip_relocation, monterey:       "d055b10dca208ac46ebc32b456588b8253323cfbdfcb9b6c1ffe830470b0170e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9dd61f17354840ea1029f6221180547b2c451c23954a9273e99d64045980c61"
  end

  depends_on "poetry" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["poetry"].opt_libexec/site_packages

    system python3, "-m", "pip", "install", *std_pip_args, "."
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
