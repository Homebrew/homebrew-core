class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/4b/31/6f26d1df7f8694479adeafa1f619dd2cfd9502089eac23bdf7fa342c9aaf/yq-3.0.1.tar.gz"
  sha256 "a5e61078facd7ee4222f4346b5b50c4e9cea5e9d3330f074b5ea2c203bf639b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33d8e2dd78a925be54583f177038622e73c61d4865f12881a0dbf9763f5b9016"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2209df21ecb94211ed6a0a501e1e35cd62f984d7a0599025e60d546effbd2452"
    sha256 cellar: :any_skip_relocation, monterey:       "e16ce617c783377de8a59958c9edec0cb7af20e81bc6f8f4495d903776b40840"
    sha256 cellar: :any_skip_relocation, big_sur:        "d18cd15fb0c23cad1500576e7a7b6b11d1cc4007064a6391334dc6b045d907ec"
    sha256 cellar: :any_skip_relocation, catalina:       "55c9c934585bca9ed5a1f2a9d35587d88d0a754dac9a1d526b6e029a27d2d147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c09bc813f8c97332f55d9a1e51d4e5a46958a5d9c8059e4fc585ca529d88908e"
  end

  depends_on "jq"
  depends_on "python@3.10"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
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
