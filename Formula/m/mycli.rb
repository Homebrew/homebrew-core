class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/20/9b/8909b7ce779ca87b10826e01a6073890937e44e44a60b1f4d2ee71f44ce6/mycli-1.27.0.tar.gz"
  sha256 "a71db5bd9c1a7d0006f4f2ff01548ce75637d3f50ca3a7e77b950b5b46aff7cd"
  license "BSD-3-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55839219b11a47f870256aa92f04f008567560969712106744d6dd3d82037197"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acd1178330cddc636dedfc222eee22554ce9d887482a356c00312f5495803245"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15cfd4b9afe0d3187fe2ad0a6fb5d721464bf98122a54d57940121473b9e9485"
    sha256 cellar: :any_skip_relocation, sonoma:         "1aa1ee1484c24727d310ca768868d8b03dd639aeae7264909359c28ef2dbb8a6"
    sha256 cellar: :any_skip_relocation, ventura:        "3979427a1cc50d42a84fcbffe661071fd756c55cb97d1380fca8dfe480d42a40"
    sha256 cellar: :any_skip_relocation, monterey:       "67022c9a86635ac70f818f69da6186e762a34b804024653c851ff68ebd453aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf58acf194f18a49188de5e268b3947e33f2a9ac299dc4c7122fec504aaed54b"
  end

  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/ab/de/79529bd31c1664415d9554c0c5029f2137afe9808f35637bbcca977d9022/cli_helpers-2.3.1.tar.gz"
    sha256 "b82a8983ceee21f180e6fd0ddb7ca8dae43c40e920951e3817f996ab204dae6a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pymysql" do
    url "https://files.pythonhosted.org/packages/41/9d/ee68dee1c8821c839bb31e6e5f40e61035a5278f7c1307dde758f0c90452/PyMySQL-1.1.0.tar.gz"
    sha256 "4f13a7df8bf36a51e81dd9f3605fede45a4878fe02f9236349fd82a3f0612f96"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/55/72/ef1432e9e85a8234db1a03afb250f445acc2dc378efe49bdde03c33f34a1/sqlglot-21.2.1.tar.gz"
    sha256 "e36170327d7faf60e5a48f60357835d69c888b852421edc3a4160cb02a84b700"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    # Click does not support bash version older than 4.4
    generate_completions_from_executable(bin/"mycli", shells:                 [:fish, :zsh],
                                                      shell_parameter_format: :click)
  end

  test do
    system bin/"mycli", "--help"
  end
end
