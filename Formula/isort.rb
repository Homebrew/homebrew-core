class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/a9/c4/dc00e42c158fc4dda2afebe57d2e948805c06d5169007f1724f0683010a9/isort-5.12.0.tar.gz"
  sha256 "8bef7dde241278824a6d83f44a544709b065191b95b6e50894bdc722fcba0504"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94af0d1b4bac94356a51f88cd8d66c6a2b8ee3981c3ea1965518a043f95856a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36013e7c59d87b8e3f92fe31a5eb86407ee61336f34e7d05677c4f9d115e080d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b24e0130404440bdd7687316b68b3eab7fce73e924c5084ba114c611a82d380"
    sha256 cellar: :any_skip_relocation, ventura:        "1595d7c52269c275beb673eff398eb87e5904e35de6efe369945507ee0a51426"
    sha256 cellar: :any_skip_relocation, monterey:       "c89d32db7a376a13d06d5d675df72457476048a8b9dc10e3c042b1ef2b0ca0c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd687d2bc483df4e8e550d138e57169591b472d404e061d256d4adcb8e8fcc67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "952ab7c281a259090b4066d1dc3b95372b817afe617774356eef0b952d953256"
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
