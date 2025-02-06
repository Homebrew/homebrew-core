class Mdformat < Formula
  include Language::Python::Virtualenv

  desc "CommonMark compliant Markdown formatter"
  homepage "https://mdformat.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/fc/eb/b5cbf2484411af039a3d4aeb53a5160fae25dd8c84af6a4243bc2f3fedb3/mdformat-0.7.22.tar.gz"
  sha256 "eef84fa8f233d3162734683c2a8a6222227a229b9206872e6139658d99acb1ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8de37d6131f8a139fd4493056489324953ac35c54314d0bfbfe3d64064fffb64"
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
