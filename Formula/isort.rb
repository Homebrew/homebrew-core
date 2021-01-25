class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/a2/f7/f50fc9555dc0fe2dc1e7f69d93f71961d052857c296cad0fb6d275b20008/isort-5.7.0.tar.gz"
  sha256 "c729845434366216d320e936b8ad6f9d681aab72dc7cbc2d51bedc3582f3ad1e"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "454f81b392904f6c3b051968349f2547be7cf142f63a34bf2771d65768c051dc" => :big_sur
    sha256 "e9eff09e8303490635ecd70945590d7449b15f4978c1651711991dece289b4d3" => :arm64_big_sur
    sha256 "0795695d5fd3d18e2b46a119acf132a66be387ad7515d5eb6f0686db4da28526" => :catalina
    sha256 "4e2beae6fc40007208704b756f4abc60c11ef04ce7e164f128bb3f22d884cf97" => :mojave
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
