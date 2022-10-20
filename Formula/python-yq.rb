class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/55/b2/0c4409c0e677ea9e6870538b4cdf4959fad92a8aaa73ee41cf03876bddf9/yq-3.1.0.tar.gz"
  sha256 "30a84aa22486c749ba269256bd586c0bcd370b7e2a71e76c3924ead4867e74f2"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f618ed2969c322c07673ad0e64da32510b0090da8572f2b5350da2d38a244a6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f618ed2969c322c07673ad0e64da32510b0090da8572f2b5350da2d38a244a6c"
    sha256 cellar: :any_skip_relocation, monterey:       "c9199b9c9789cb4ca659ee69f2b19be0ccdd1bd863ca5535c7113a77f69e35a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9199b9c9789cb4ca659ee69f2b19be0ccdd1bd863ca5535c7113a77f69e35a3"
    sha256 cellar: :any_skip_relocation, catalina:       "c9199b9c9789cb4ca659ee69f2b19be0ccdd1bd863ca5535c7113a77f69e35a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51b78effa4a3b865f2f9915e709410a6551b7302b4109831b0b1e2880127a7a6"
  end

  depends_on "jq"
  depends_on "python@3.10"
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
