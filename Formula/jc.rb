class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/6b/42/230238116c510ce403c0ae0d92ab790d524dd5bbe6d32cc722f0be43a0d8/jc-1.21.1.tar.gz"
  sha256 "de4a6399f265cf9250f0883d415ab5c5a081d165ead80c38a27da68fe71a4563"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "914515a780ecd541439bf7b4b2ca685e9671fd28ac7f50516d9c208445f98213"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77a0b9aa704d90bcfaf543f39a9116a7ebdebc1c041b395e4215bf4c9df61f75"
    sha256 cellar: :any_skip_relocation, monterey:       "3f4e7a8ec85ebe581c6535e22520595fe37cf894d1f30b3f9d6b0547c30e5ba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3378cad7c52a9d0b56ecbfa33b04c8058251734e69680d00ffec05db84ffbaf4"
    sha256 cellar: :any_skip_relocation, catalina:       "d5bb7c295349ad27774ce4a15cee4d4aedc1f969f5a98d78c84ea31c12888487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc27946d2d886e47513f314251709ede017483a82155557c515dff7c2e5d2399"
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
