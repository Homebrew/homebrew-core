class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/e3/c6/adfbfb59eda5d2eccf2e0af9e906b9919febe62bc444f2f5891944c2be9f/yq-3.2.3.tar.gz"
  sha256 "29c8fe1d36b4f64163f4d01314c6ae217539870f610216dee6025dfb5eafafb1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db3864640973d526af738763f6da4d807bd3b19c91dd1d172ac58c3aaa07e2ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "476feec14d96b655ff455e29c414d7e4f06332b00c2fe28045c842e7d92fb806"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f9732056b6f510c14477c7f892752e73168dd21ca69153592885f32fbf18f29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c97e327af55020778a3bdfdf9c90f022b3f88f6dcf933982877dd6e566e0c015"
    sha256 cellar: :any_skip_relocation, sonoma:         "edf692f05311402dad10d01cfcf17f9af83a1d46b29dc674e3f470de1486ce9d"
    sha256 cellar: :any_skip_relocation, ventura:        "525a1bd76e8951314f4f5838f22bab9e8faefd72ee35a77731a5bc60dc0bf1b8"
    sha256 cellar: :any_skip_relocation, monterey:       "829ded8db7bb36d0782733f442b590be0b8431559f07703fca947aff298a44eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "94c7565cc78e0fcfd51c4308839f05d474b2bad98083098367b18edd148a5942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dff3e7410fcd55fd98ec77d1d2d267191c0a66cf61353f6045ce53eeb42d23df"
  end

  depends_on "jq"
  depends_on "python@3.11"
  depends_on "pyyaml"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
  end

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
