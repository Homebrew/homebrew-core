class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/4e/34/64f8a43736d9862ced7dd0ea5c3ed99815b8ff4b826a4f3bfd3a1b0639b1/flake8-7.1.0.tar.gz"
  sha256 "48a07b626b55236e0fb4784ee69a465fbf59d79eec1f5b4785c3d3bc57d17aa5"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49ddf4432cde384acabb20c358a1aef419cb49d0a568d6dc5b7f467a8191f180"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49ddf4432cde384acabb20c358a1aef419cb49d0a568d6dc5b7f467a8191f180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49ddf4432cde384acabb20c358a1aef419cb49d0a568d6dc5b7f467a8191f180"
    sha256 cellar: :any_skip_relocation, sonoma:         "57430b00e092ae642ca5be869e51348531fc14e7b6909f720ffa848c0969f0ba"
    sha256 cellar: :any_skip_relocation, ventura:        "57430b00e092ae642ca5be869e51348531fc14e7b6909f720ffa848c0969f0ba"
    sha256 cellar: :any_skip_relocation, monterey:       "57430b00e092ae642ca5be869e51348531fc14e7b6909f720ffa848c0969f0ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5131306521c0df505d4350b7b7cd7a0db851547d6b6b85f64f7a28162568fe1"
  end

  depends_on "python@3.12"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/10/56/52d8283e1a1c85695291040192776931782831e21117c84311cbdd63f70c/pycodestyle-2.12.0.tar.gz"
    sha256 "442f950141b4f43df752dd303511ffded3a04c2b6fb7f65980574f0c31e6e79c"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/57/f9/669d8c9c86613c9d568757c7f5824bd3197d7b1c6c27553bc5618a27cce2/pyflakes-3.2.0.tar.gz"
    sha256 "1c61603ff154621fb2a9172037d84dca3500def8c8b630657d1701f026f8af3f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-bad.py").write <<~EOS
      print ("Hello World!")
    EOS

    (testpath/"test-good.py").write <<~EOS
      print("Hello World!")
    EOS

    assert_match "E211", shell_output("#{bin}/flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}/flake8 test-good.py")
  end
end
