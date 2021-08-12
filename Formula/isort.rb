class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/1c/34/ed9178b5b23ade4561bf77b91856e0e3bc094620fd81bd74d535817a0f0d/isort-5.9.3.tar.gz"
  sha256 "9c2ea1e62d871267b78307fe511c0838ba0da28698c5732d54e2790bf3ba9899"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "433f9927ca1b68c347cb27f3989c1e341baeaaca18847329204827c73331bbf2"
    sha256 cellar: :any_skip_relocation, big_sur:       "8267b3253e03e3ec2a6cae7120852ee059ce8082b43a6494e8555f350342be7c"
    sha256 cellar: :any_skip_relocation, catalina:      "3363201814d2c95acae1ba563983961b104382ac528f55192403fa07fd1913c7"
    sha256 cellar: :any_skip_relocation, mojave:        "e9527931d13450a51c1399ee6d583f02f0fd10ad0afbd005914b768adf4f931c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc7e92c173a5265d7c3482a5e654f745cc6ff6f7c1976f08b0a1122853124d8d"
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
