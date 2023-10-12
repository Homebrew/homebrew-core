class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/e3/c6/adfbfb59eda5d2eccf2e0af9e906b9919febe62bc444f2f5891944c2be9f/yq-3.2.3.tar.gz"
  sha256 "29c8fe1d36b4f64163f4d01314c6ae217539870f610216dee6025dfb5eafafb1"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6574c6cbda104497526069a2456d5d1240b8a6be3ed6e825103311a4d21ae146"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0f4e9b7a3f4dacc8cd3146dc8bc97897531557fd42ed0f689eba7a576f81f88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ba2b2b9aecd31d9584bb01ce229e0d9627a0400a633a74d6ab58444bbe56e91"
    sha256 cellar: :any_skip_relocation, sonoma:         "75752c0236ad1b8e11bff43d60885fa6390003cf1c47bed3ced5fb3ae8bdfcb4"
    sha256 cellar: :any_skip_relocation, ventura:        "4ec6a60524dedfd296b4376c3455feefb72ad04cdeee7b6f32720989c7446739"
    sha256 cellar: :any_skip_relocation, monterey:       "2f3757e2c3a42b12f581e335a01c47fda679c4c9cd21f807d5e330ea65203b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73863bb1cda14a115569a3086daa1e8a6bdd16c84418403b967d589b1a0177c5"
  end

  depends_on "jq"
  depends_on "python-argcomplete"
  depends_on "python@3.11"
  depends_on "pyyaml"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    input = <<~EOS
      foo:
       bar: 1
       baz: {bat: 3}
    EOS
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
