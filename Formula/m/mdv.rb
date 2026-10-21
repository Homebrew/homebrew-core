class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "091705d25749fcb42f4b9b8a8a1fc9d594a3fa19789e4ffdb63449787306a8d4"
    sha256 cellar: :any, arm64_tahoe:       "fc2931ddac09fd9141814affe336efa306abd1571e7a8835ba0efbf3f31c226c"
    sha256 cellar: :any, arm64_sequoia:     "be288bc4aff8d4e4b443be085a1bbb8b4306323f40a1693ee85488f0512df8cb"
    sha256 cellar: :any, arm64_linux:       "10245bd506c8a0f0d9d69890e04c594ca767f1eee7222c2df51fc6fe8b095ce6"
    sha256 cellar: :any, x86_64_linux:      "43fe07ae0ab0db6087249248e649c7b2685413c4ae0da26f83a74abc4804e38d"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages package_name: "mdv[yaml]"

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/f8/4f/700155c8c20d9e655dd0732b5fc3c7614f291b9148da271d7388e50bf774/markdown-3.11.tar.gz"
    sha256 "180224db6aed87ba9ce1f2781ebcd5826253de8ff637112090e24b84502bbf9f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      # Header 1
      ## Header 2
      ### Header 3
    MARKDOWN
    system bin/"mdv", testpath/"test.md"
  end
end
