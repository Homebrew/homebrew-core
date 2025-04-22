class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_sequoia: "ef4e272237c57fc919e84a83ec656a2573fc2c2e9abcb1f8ee38337674c4547d"
    sha256 cellar: :any,                 arm64_sonoma:  "01a862f7035899d724bbeed466ad5ab40ade22df6a1ff1bd6c925c2771d27a52"
    sha256 cellar: :any,                 arm64_ventura: "339a027a25e48fb1e5c1a5cdb0315413d2a22852d01fce952590cfaac67bc1ed"
    sha256 cellar: :any,                 sonoma:        "8b80fe566da1c2fadee35bee233b56184e4a48e7c21faeda2a564d2d8112ffe8"
    sha256 cellar: :any,                 ventura:       "12e0ea9ebce34b1860ad367c9e22e0939307015a31e7dc3ea35b49476fd14d38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d26f20621c5873d0dba005a698850a57371ad314eeda2648546021c32ba6787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e0a7931adf9d985ed1cb030375174607fc4fd2b676d3e28dbc193558bde2f9c"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/54/28/3af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472/markdown-3.7.tar.gz"
    sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
    system bin/"mdv", "#{testpath}/test.md"
  end
end
