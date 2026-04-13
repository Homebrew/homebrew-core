class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e3f993dff2c2285c95d307052eb788af49064b39416a4af601f1b6c8ccff2ed"
    sha256 cellar: :any,                 arm64_sequoia: "2b2066297ec9e9fe3a49ebab06160e6a8c40b13e70ae5c2afe1e67a2066923b9"
    sha256 cellar: :any,                 arm64_sonoma:  "4948a815dfb995aafe81414e4c8ff8cedf80654574d8521bb71c2aff69e9955c"
    sha256 cellar: :any,                 sonoma:        "182702c80f2feeb950166ccff5f33825d02207948503d3a540c808836b749cd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcae45fe0cd6e612aa92fce775f120a8414c2937005f0d1821712abd29f1820e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db5f55e163a5bcdfcc3e2cb15ac45717470850c7c980145ba9fc5e0ff54813e"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages package_name: "mdv[yaml]"

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/2b/f4/69fa6ed85ae003c2378ffa8f6d2e3234662abd02c10d216c0ba96081a238/markdown-3.10.2.tar.gz"
    sha256 "994d51325d25ad8aa7ce4ebaec003febcce822c3f8c911e3b17c52f7f589f950"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
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
