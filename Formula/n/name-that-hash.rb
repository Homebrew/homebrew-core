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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "766c5c79c52c0f7245b5f44cffc17775e5bb6d18bcfbddeeb0ba1722f63c2e12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb37bf57449d7fece239db2426f9ab32c47ffe9fb569ae3c997dec35bb5745ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af6746b01f9ff889c5a18c6ae4f0171520fbbc831c970fbbe977fc98c085fa4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a47200d84de240fb4ab86fb31aa3eba4e3dffef0acf85c8e097590a1f3c6eeb5"
    sha256 cellar: :any_skip_relocation, ventura:        "a96f06925076b05c8b4050be22e8df0617f78b2e039122abd5482322293da5c4"
    sha256 cellar: :any_skip_relocation, monterey:       "1aea54b9face4783b7a1b031e734c352de7add4310d42c3a5b594d51b182d6b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1109a0e0fdb05230d9e6084dd2761590b5382f1786722c1c4afd75d32a23db1d"
  end

  depends_on "pygments"
  depends_on "python-click"
  depends_on "python@3.12"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
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
