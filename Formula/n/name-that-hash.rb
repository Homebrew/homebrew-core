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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cec5b9102cf914f69608410f9a0d008bd0dbe2de41118f6c25583ad817bf0843"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba3919fafff1b9e66edf899e72961ebc017d62e11aa6fd47fd1e783737e684cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60da52181882609929ef7a0b87a24fabfd50c7ff824bc670c1795eab69a0a7b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "23b5a2cd17378d9916e9af5f20877c08abae157224233b557159ca53dd0cb1df"
    sha256 cellar: :any_skip_relocation, ventura:        "2ec1c9f43f7013fd62492b69dbf2e9dd0ecad1b8dc6ad404c7d400f8a1ab6aec"
    sha256 cellar: :any_skip_relocation, monterey:       "09621962e8d7c29333ec349e6ffcc06b9cb8b73a6a90a1addbb9009b3517bdd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5241f1aa403fcdda222e52093a27fad168554400a47f2e1449e7466c77543bee"
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

  def install
    virtualenv_install_with_resources
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}/nth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "MD5, HC: 0 JtR: raw-md5 Summary: Used for Linux Shadow files.\n", output
  end
end
