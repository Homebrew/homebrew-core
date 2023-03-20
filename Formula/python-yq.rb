class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/6e/94/e8401c429419a1d5fa8e2996fdcfa564367a29b88f97d8bfef9138ff5f39/yq-3.1.1.tar.gz"
  sha256 "853f342b1562ddee979038ec8ecee5405cdd9b6a7cb81ed6cdb8018c9e802633"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f39946c75ed346f336025878451f89c050d87e5742db9553d2c15d82f7e94bb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2adad568d731c2edc2c01749662013a71497c50563e64f723b6372d2b3495d00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0616b28424ae076d9d69b2122988eb993614d04dce20cdb636f00d3a8b8c9581"
    sha256 cellar: :any_skip_relocation, ventura:        "7133a60fe44b9ac23c7c2b7f1acdf8b347bd25666baa7cc1559b80bc30ac5399"
    sha256 cellar: :any_skip_relocation, monterey:       "ff3d26f949489f6bfab593cc57efbd2dd1f9f2f99f08e00754c26008aa97fafa"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a700884cd22a3caac6ae2eae49f7f64b49a3ae8b378e2fd67435108758a2d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c974b566846e4e53eac1735730468cafd789b9b6f8f374a8f2da6a37bc49e9de"
  end

  depends_on "jq"
  depends_on "python@3.11"
  depends_on "pyyaml"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
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
