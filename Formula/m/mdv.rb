class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f6de617a2cbecc970673a7ec47d098f43abd079d8d6a021f4b7785ef8dcf374"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14350a360592220984c9d62be076631c7e80e47f67fb95a547e25ee336ff75ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2bb088679117e8008e856b478e1b1f30f4d343f8860e3a35de5bcf84ab4199c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fc8735b48352547eb5417ff16abb4506a0ff4ffabab613af1c9cb3185371117"
    sha256 cellar: :any_skip_relocation, ventura:        "00d97593906271ca6da2a01f7c8e8dc0d159936d314efc55c3cc90204781279e"
    sha256 cellar: :any_skip_relocation, monterey:       "1ab21c351a5fc98d7a376aabb88bcf9f566e0e583e32d515be0ed245783dd3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57ebe8bbb634bbc88fd57785e791eab18de60599a4ad2cb7c9f2abf7693dc713"
  end

  depends_on "pygments"
  depends_on "python-markdown"
  depends_on "python@3.11"
  depends_on "pyyaml"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write <<~EOS
      # Header 1
      ## Header 2
      ### Header 3
    EOS
    system "#{bin}/mdv", "#{testpath}/test.md"
  end
end
