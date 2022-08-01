class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/55/b2/0c4409c0e677ea9e6870538b4cdf4959fad92a8aaa73ee41cf03876bddf9/yq-3.1.0.tar.gz"
  sha256 "30a84aa22486c749ba269256bd586c0bcd370b7e2a71e76c3924ead4867e74f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22fa2dcf0dd119763e22ec1a0c978e2679ec55851f8890740b38faee86f3379d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19f4e41594f42119106b8d2ec8f9265efd0765f9b5486eaf3f8cb2ca644d90f9"
    sha256 cellar: :any_skip_relocation, monterey:       "bfdac2875046eb01447e25fd9ef60f297806e3c307cf319fe0e0a7ba63136138"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab7037ff95e933ab88f90fcb5c7d6f05f6fcb823110f5c675cbd397c99ae5091"
    sha256 cellar: :any_skip_relocation, catalina:       "f71b841046cc531d0b777ce606bc6845c2bb841b393171e7dca92ed2e1edfc6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f42debb39fdc2c4d078efce41e46565282b4e1d3808ce027b7459facbe82f0fb"
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
