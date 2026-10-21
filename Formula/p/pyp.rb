class Pyp < Formula
  include Language::Python::Virtualenv

  desc "Easily run Python at the shell! Magical, but never mysterious"
  homepage "https://github.com/hauntsaninja/pyp"
  url "https://files.pythonhosted.org/packages/0c/65/c275ff380e4412438577eab23810dd7a1ba2cf54a6ba558a3d22cf0fb68b/pypyp-1.3.0.tar.gz"
  sha256 "97c78f8fd6d4550bf67bb5001a4c5c1fa58184d9bd8256abac3e240fa38aa05c"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "83133553a92fc04cf6dccfd8c57cdccc6555b4012e1a2f318539d3042bdc276d"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyp --version")
    assert_equal "6", pipe_output("#{bin}/pyp 'sum(map(int, stdin))'", "1\n2\n3\n", 0).strip
  end
end
