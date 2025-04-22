class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/8f/2d/b91fcde276a783fbca94b54cb9b91ce3a506dfb4390fa603c0389b029ec4/mycli-1.30.0.tar.gz"
  sha256 "e8822cd4ce721badfe485122a502e030965668e426e75db9b8a0dd2efe0bd675"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfe3f9646439a7264bf6c076a55f21b4ea4255e4ccb43aafeca15043f68376cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfe3f9646439a7264bf6c076a55f21b4ea4255e4ccb43aafeca15043f68376cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfe3f9646439a7264bf6c076a55f21b4ea4255e4ccb43aafeca15043f68376cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b2a4e0fd5eba647e3d797ae50d492ab0613a6988d7d256c51d1fc365531c67e"
    sha256 cellar: :any_skip_relocation, ventura:       "5b2a4e0fd5eba647e3d797ae50d492ab0613a6988d7d256c51d1fc365531c67e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfe3f9646439a7264bf6c076a55f21b4ea4255e4ccb43aafeca15043f68376cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfe3f9646439a7264bf6c076a55f21b4ea4255e4ccb43aafeca15043f68376cb"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/f9/7c/3344a9b856b9582df36c7a525f5710294f349499d16dcbf343453f70bdb8/cli_helpers-2.4.0.tar.gz"
    sha256 "55903b705a212a473731db20fa26f58655e354078b99cb13c99ec06940287a4d"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "pyfzf" do
    url "https://files.pythonhosted.org/packages/d4/4c/c0c658a1e1e9f0e01932990d7947579515fe048d0a515f07458ecd992b8f/pyfzf-0.3.1.tar.gz"
    sha256 "dd902e34cffeca9c3082f96131593dd20b4b3a9bba5b9dde1b0688e424b46bd2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pymysql" do
    url "https://files.pythonhosted.org/packages/b3/8f/ce59b5e5ed4ce8512f879ff1fa5ab699d211ae2495f1adaa5fbba2a1eada/pymysql-1.1.1.tar.gz"
    sha256 "e127611aaf2b417403c60bf4dc570124aeb4a57f5f37b8e95ae399a42f904cd0"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/ac/16/57112d89a61f4329047921b2df09ac3caac1e006153bcfc662157211997f/sqlglot-26.15.0.tar.gz"
    sha256 "8349b782b8cee8b0ec6d228341a6564de562bdb7d87e7843e4849e9bf576e9a9"
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
