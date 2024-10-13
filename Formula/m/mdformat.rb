class Mdformat < Formula
  include Language::Python::Virtualenv

  desc "CommonMark compliant Markdown formatter"
  homepage "https://mdformat.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/df/86/6374cc48a89862cfc8e350a65d6af47792e83e7684f13e1222afce110a41/mdformat-0.7.17.tar.gz"
  sha256 "a9dbb1838d43bb1e6f03bd5dca9412c552544a9bc42d6abb5dc32adfe8ae7c0d"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a48017897bf41a9d8b3bb7a7915f1ed506b5739263cde85242a8cc569fd7130f"
  end

  depends_on "python@3.13"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# mdformat")
    system bin/"mdformat", testpath
  end
end
