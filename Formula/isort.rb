class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/ac/2a/87e6a7d3c3953ddfb37c6da3fd951490425a60d2ab0be059b321d5788dc8/isort-5.9.2.tar.gz"
  sha256 "f65ce5bd4cbc6abdfbe29afc2f0245538ab358c14590912df638033f157d555e"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b6ee338a2f23a497ca00366c61f37b715706853f71f24f86364312333be5373"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f74871a6fac08d40dab69862f01cde96891370f21dee524f051f614c2710d52"
    sha256 cellar: :any_skip_relocation, catalina:      "4e49aad4bce47aadd0a00cf6579e567a5d21eac7e487c61b980c820b8e928ae1"
    sha256 cellar: :any_skip_relocation, mojave:        "120c5d1d55fefe15d0d921553785574efe85e3bef376941c39caf3c691d85eea"
  end

  depends_on "python@3.9"

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
