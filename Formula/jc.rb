class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/30/77/e5f82206568c4729bd9a568d7cbd3112784fcb81a4500779aa8e83ddf6ba/jc-1.22.1.tar.gz"
  sha256 "57d6e5d6ded87b2fcc08be715a3aed326e930cb5c9d7abcc9e4d57fa8229189a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29886790e79ae0016ca3e4f3315f30d323d400626b5e7e95b8ce76b7f8a9a51e"
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
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
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
