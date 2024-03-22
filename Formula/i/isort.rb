class Isort < Formula
  include Language::Python::Virtualenv

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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2190b1a4860ba5e7ad437a5c0c37a6ba8ad54f19cb4fef15f914a9710356d636"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2190b1a4860ba5e7ad437a5c0c37a6ba8ad54f19cb4fef15f914a9710356d636"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2190b1a4860ba5e7ad437a5c0c37a6ba8ad54f19cb4fef15f914a9710356d636"
    sha256 cellar: :any_skip_relocation, sonoma:         "2190b1a4860ba5e7ad437a5c0c37a6ba8ad54f19cb4fef15f914a9710356d636"
    sha256 cellar: :any_skip_relocation, ventura:        "2190b1a4860ba5e7ad437a5c0c37a6ba8ad54f19cb4fef15f914a9710356d636"
    sha256 cellar: :any_skip_relocation, monterey:       "2190b1a4860ba5e7ad437a5c0c37a6ba8ad54f19cb4fef15f914a9710356d636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af37731a0ce2a0eca9cfad575039cf7a300ca79e0b705628d91de2130d92e03c"
  end

  depends_on "python@3.12"

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
