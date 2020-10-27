class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/7b/b5/19e828baf02d3e441cd287a3f3cc172bec2d1210c0210294debeddbd3550/isort-5.6.4.tar.gz"
  sha256 "dcaeec1b5f0eca77faea2a35ab790b4f3680ff75590bfcb7145986905aab2f58"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
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
