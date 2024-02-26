class NameThatHash < Formula
  include Language::Python::Virtualenv

  desc "Modern hash identification system"
  homepage "https://nth.skerritt.blog/"
  url "https://files.pythonhosted.org/packages/7a/d6/5bea2b09a8b4dbfd92610432dbbcdda9f983be3de770a296df957fed5d06/name_that_hash-1.11.0.tar.gz"
  sha256 "6978a2659ce6d38c330ab8057b78bccac00bc3e87138f2774bec3af2276b0303"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/HashPals/Name-That-Hash.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "001b94fecd0ed9c758642dad31bb0c5e25bcfaf2c6239b8a552420916434200a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3ebfe84ebf67ab12bcfb95a21066f92a8abae695dbb6047415c3703262ec22d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca781f0a92c0d322e868f5e2b5852f42838f3d796ec2c00ad9999826317eb6be"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7d6d4814ea801742b4c18087c9c59b92183530d60ddb7725a9403d3eafdebda"
    sha256 cellar: :any_skip_relocation, ventura:        "efbef54d10ec00010d046c36378973796319c792f5ec87790d356d7d1fcca4d5"
    sha256 cellar: :any_skip_relocation, monterey:       "ea73e88e7a8b9614380020190c8a9278ff2976384fa1cae1173bad825b2aefa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbeb454f367940c58b9e72b8844e26f9b1206cbad7e958489d68b9015f23cee8"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  def python3
    "python3.12"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-name_that_hash.pth").write pth_contents
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}/nth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "MD5, HC: 0 JtR: raw-md5 Summary: Used for Linux Shadow files.\n", output

    system python3, "-c", "from name_that_hash import runner"
  end
end
