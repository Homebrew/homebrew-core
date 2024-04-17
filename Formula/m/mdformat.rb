class Mdformat < Formula
  include Language::Python::Virtualenv

  desc "CommonMark compliant Markdown formatter"
  homepage "https://mdformat.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/df/86/6374cc48a89862cfc8e350a65d6af47792e83e7684f13e1222afce110a41/mdformat-0.7.17.tar.gz"
  sha256 "a9dbb1838d43bb1e6f03bd5dca9412c552544a9bc42d6abb5dc32adfe8ae7c0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14024bedc37d382d69cf4bdc4d6da652920d83b238c17c5e4bfa5078bc40e2bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14024bedc37d382d69cf4bdc4d6da652920d83b238c17c5e4bfa5078bc40e2bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14024bedc37d382d69cf4bdc4d6da652920d83b238c17c5e4bfa5078bc40e2bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "14024bedc37d382d69cf4bdc4d6da652920d83b238c17c5e4bfa5078bc40e2bc"
    sha256 cellar: :any_skip_relocation, ventura:        "14024bedc37d382d69cf4bdc4d6da652920d83b238c17c5e4bfa5078bc40e2bc"
    sha256 cellar: :any_skip_relocation, monterey:       "14024bedc37d382d69cf4bdc4d6da652920d83b238c17c5e4bfa5078bc40e2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c5d61f62ab333861eccbfeaf1a7a9f4b8d09f0fc68a620a0a1c90146af14a2f"
  end

  depends_on "python@3.12"

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
    system "#{bin}/mdformat", testpath
  end
end
