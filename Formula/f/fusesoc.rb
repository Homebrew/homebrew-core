class Fusesoc < Formula
  include Language::Python::Virtualenv

  desc "Package manager and build abstraction tool for HDL code"
  homepage "https://fusesoc.net"
  url "https://github.com/olofk/fusesoc/archive/refs/tags/2.4.6.tar.gz"
  sha256 "e0ceb507665ee59202701ad161abee9bd1a8fa172ae09973a11b97d65b6ba83d"
  license "BSD-2-Clause"

  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages package_name: "", extra_packages: %w[edalize pyparsing pyyaml simplesat fastjsonschema argcomplete]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "edalize" do
    url "https://files.pythonhosted.org/packages/5e/77/e7b0f6b96c6eafdb798a8b7a4c76c064522d94aecb7fc0ea442ff7d6291b/edalize-0.6.8.tar.gz"
    sha256 "d1d2b9d441789c718e7480c9c4ce55fd39b463f2a7f0f328da1daed7179b1e72"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/e4/98/474719c58eddaf77fa443b063693e76d49db32bbe851bcbaf58d2700119f/fastjsonschema-2.22.1.tar.gz"
    sha256 "0b83d1ce8d7845b959dcb20e1a5c3c8883b6541d9c52ab02cce5166b75ec805f"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "okonomiyaki" do
    url "https://files.pythonhosted.org/packages/f2/95/2a3cde9beff788a9ec34d64525e509e3ae4d4053669ae1be30a000fdee5b/okonomiyaki-3.0.0.tar.gz"
    sha256 "f5de606542d27821fda1a59c4e13dfa9adf227a0e4dc28a408e280918b54b70e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "simplesat" do
    url "https://files.pythonhosted.org/packages/24/60/9c4a2534ae17dc5397c0536c3875a6ea8acf5d65f099ae617ce676433f3b/simplesat-0.9.2.tar.gz"
    sha256 "8cb800d09289bdc051126e725949368f8ac25105d40865cb93aa20eae9d46a9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fusesoc --version")
  end
end
