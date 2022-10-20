class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/8a/db/f2d29bc2d86109cd5e5f3922621572cc36874502879eace648f743b7f777/jc-1.22.0.tar.gz"
  sha256 "0cb5ba460f0a7e3831005a7520f5a12d831670d705422c7b650b0f843c229784"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b2af45e783bf053d58014e981251617c87d0559a959822657354c09c5ffa069"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b00f2179b7bebb61b19cf1f87843a2b452279b2ab88ba39b845975dada5b0320"
    sha256 cellar: :any_skip_relocation, monterey:       "e5db8b2293f55941c7f531267f1bc7107c422b4e6fa648fb6efcb45eb20ef4b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6117b252520f50c5e2c63df97f9c702fb0047249047873bd350bc8a23bd5ad0e"
    sha256 cellar: :any_skip_relocation, catalina:       "6baea80f11d8a4064c36761b4af3c0156692b607ffe3fa6dbf81b592c64139be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ccc89b2f09f2479ed00786789523f9fe983e0ad07c11fdf245c2f33c1f5a011"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
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
