class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/45/d8/92927765b10e27b2bc9099626a3d8196439dd2fc61854e4633a8f47843d0/jc-1.20.4.tar.gz"
  sha256 "28a4cbb1f52231d479fe2bbf935af504870a7e9072b5f0b259767f4f15feaa0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dfd4fc7b53f33b7a5a977dcab8ccf5407e4c06b0a25cc04f7af046d9e141b85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45fde8d7a48c7cb39515b3241ffb317871b28fa20bfb833724bbc80f278a7470"
    sha256 cellar: :any_skip_relocation, monterey:       "36643e294b2bb4ea7570d661b74c2f10e24e999ca95821ea4d9f12e6b48cc5ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "85b1c1954fdd3d780b0d65d61bb8176824611abe0dd389b4a3cf13bb84edf14e"
    sha256 cellar: :any_skip_relocation, catalina:       "282dcc4abb0596a97cdd0ac1f9e9c6ec2f6ae85c6cca9405fc11c80cd94ddb41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d7d91ba0612cfb4cc6042c4c5129b506f73d755611565aeeb363403bb284d10"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jc.1"
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
