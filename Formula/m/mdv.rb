class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "a2fca7b5066ffec483e3334ee021c2165b69767e89bd883dd744107fe61a7410"
    sha256 cellar: :any,                 arm64_ventura:  "e46e133e37e80d0bf8cef00c329d6d83f2edffe4844d6b51e90d1369f0337cc7"
    sha256 cellar: :any,                 arm64_monterey: "c1483e7152c649c7599c727339e18d4c29e6b072886bd257296441f78ff9acf6"
    sha256 cellar: :any,                 sonoma:         "e8f8f7c52d3a2bf1bc3dca1a41e40981de6ebe5bfdb92942154d3719096a074e"
    sha256 cellar: :any,                 ventura:        "f1ace8ac0376b82ec336fb54f4cf00577d1c13e7a2745a0c0b8243e89c558554"
    sha256 cellar: :any,                 monterey:       "0aad2a912ab73605a010eda5e5d746ce8dffaae0fc54fd540a486426d80e235a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67e68c2e3d0fdd937eba2a890e6482cd65f7bfbd87df293660df31d78e3136b3"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/11/28/c5441a6642681d92de56063fa7984df56f783d3f1eba518dc3e7a253b606/Markdown-3.5.2.tar.gz"
    sha256 "e1ac7b3dc550ee80e602e71c1d168002f062e49f1b11e26a36264dafd4df2ef8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write <<~EOS
      # Header 1
      ## Header 2
      ### Header 3
    EOS
    system bin/"mdv", "#{testpath}/test.md"
  end
end
