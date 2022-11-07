class NameThatHash < Formula
  include Language::Python::Virtualenv

  desc "Modern hash identification system"
  homepage "https://nth.skerritt.blog/"
  url "https://files.pythonhosted.org/packages/32/58/1f4052bd4999c5aceb51c813cc8ef32838561c8fb18f90cf4b86df6bd818/name-that-hash-1.10.0.tar.gz"
  sha256 "aabe1a3e23f5f8ca1ef6522eb1adcd5c69b5fed3961371ed84a22fc86ee648a2"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/HashPals/Name-That-Hash.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "690f64fd6219fe0663b9f1a5e82878ab1f778ff8ae7d5d1ac9d057c0a96934c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6d2ec69762f0751d28c47d1b1f9baa6cba546570521a4898e584eca07eb34b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1437e050afdd7cf7227f99291ca4a13dadff86344d0a7adb22571cb7b678602a"
    sha256 cellar: :any_skip_relocation, monterey:       "a48971481563af910804aa80cd2b27a36623893172ed002c202358b0783322f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbdeb7f5a48fb500dd53fb00cfd0c65e7ea1dc45b70b0b3f54ddd9694c1d2ff2"
    sha256 cellar: :any_skip_relocation, catalina:       "ea1513c35ed319ff5f9790aa250104a5f913ababd5c97963ea32048c186b7937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf88ca226e5e04567c9f95fd839866853fcfa413e5ab4b16d805a126db752ad4"
  end

  depends_on "python@3.11"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/74/c3/e55ebdd66540503cee29cd3bb18a90bcfd5587a0cf3680173c368be56093/rich-10.16.2.tar.gz"
    sha256 "720974689960e06c2efdb54327f8bf0cdbdf4eae4ad73b6c94213cad405c371b"
  end

  def python3
    "python3.11"
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
