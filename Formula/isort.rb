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
    sha256 "cfe5ce4ffe7f57604fd65e1b0a6ed9c60d9eb4e477113be0eef8e8d3dcf1da90" => :big_sur
    sha256 "e6a660bbbd1ef484216d17ed965ace924faaaa7477e8f2c512d13847096c01d1" => :arm64_big_sur
    sha256 "ee43e1f2f07c6d309ea19e1001e740feed67db1a27b8f03a415e513ea34e73e1" => :catalina
    sha256 "d1f54b06f018f33ac11c15f960c4f192c0c489ecb8dbb42df6496cd6a0856e22" => :mojave
    sha256 "7b4fb7d120f70e8cd5b785ccf44cef6da8eac9d879735363f29f557c3e1582ec" => :high_sierra
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
