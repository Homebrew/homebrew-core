class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/90/a0/ddb66d2e527626288a9b526af5c21bc0e590622faa1d0425808ad75f6bc5/yq-3.2.2.tar.gz"
  sha256 "8dbb7a0c937ddbfc3dd175e6478f40960c140d3e8b1f1a0315de76384d66650a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8462cbcf64af6c1e2be73b44e6abc4ae14ba264eb728f0970e2fbac37a31f9d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72e936fbdaf805e71aefdc1a996685fc12033b2bbb3b11838210c1ddbea13c37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3120fc51a4d7b8c754e945c2c8584311f7b4c70797343e485c260a75a2b148f"
    sha256 cellar: :any_skip_relocation, ventura:        "3b96bfc6ba0dcca57be1a7db8b38537b40d84fdc61a6c10e7933c2f6b4110fe1"
    sha256 cellar: :any_skip_relocation, monterey:       "5c53971c90bb5e41b81f81dbe249a43390eef91d5dec102305647ac2aa2bd915"
    sha256 cellar: :any_skip_relocation, big_sur:        "88b7c82ad5368b2318dc174d0d79679dc21851467a0202bf2cd7a71cbc8d48c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84063b1d958d69680857044d79f015f9fbd78d1407df4b6df35fc0fef1d59d25"
  end

  depends_on "jq"
  depends_on "python@3.11"
  depends_on "pyyaml"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6e/5b/9eae020dad132502efdb51408ba8a5b21afedcb738a98a307c6bfc21aaa8/argcomplete-3.0.6.tar.gz"
    sha256 "9fe49c66ba963b81b64025f74bfbd0275619a6bde1c7370654dc365d4ecc9a0b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/4d/4e/6cb8a301134315e37929763f7a45c3598dfb21e8d9b94e6846c87531886c/tomlkit-0.11.7.tar.gz"
    sha256 "f392ef70ad87a672f02519f99967d28a4d3047133e2d1df936511465fbb3791d"
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
