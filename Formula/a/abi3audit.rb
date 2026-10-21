class Abi3audit < Formula
  include Language::Python::Virtualenv

  desc "Scans Python packages for abi3 violations and inconsistencies"
  homepage "https://github.com/pypa/abi3audit"
  url "https://files.pythonhosted.org/packages/99/2d/fa16448d36021e36caa71acda36e25be8f6315b9c740b1be8bdae5c76257/abi3audit-0.0.26.tar.gz"
  sha256 "44b5fa5ddc8acdfdbd221f400d48b8a205df519e8f4c6d57a349837ac88d0ff8"
  license "MIT"
  revision 5

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7696e30c03be5fb8ce445ab25e823fe6e2bec1692d7addebab505b89060bfe69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7696e30c03be5fb8ce445ab25e823fe6e2bec1692d7addebab505b89060bfe69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7696e30c03be5fb8ce445ab25e823fe6e2bec1692d7addebab505b89060bfe69"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "685aca2a84f158cb28563f6c845ee1d671b44c70f88ddfcebaf91e46eb647056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "685aca2a84f158cb28563f6c845ee1d671b44c70f88ddfcebaf91e46eb647056"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "certifi"
  depends_on "python@3.15"

  on_linux do
    depends_on "rust" => :build
  end

  pypi_packages exclude_packages: "certifi"

  resource "abi3info" do
    url "https://files.pythonhosted.org/packages/79/69/e297e349b9ce7190f24acb38d8417ef90cb202899faf7fe66d21b257b750/abi3info-2026.9.25.tar.gz"
    sha256 "bfca7d2845517c15cee1ae5c4be0d4803070ac6837e9b0c4da1317b72b64dbc9"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/23/75/e72b839c3dc869c990b4842f3dba730bdcdf5215f68fc7955edf849a1792/cattrs-26.2.1.tar.gz"
    sha256 "679132bfdc225c5ee40c024fc42519954767c387f950dc6751946c586bccdc6d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "kaitaistruct" do
    url "https://files.pythonhosted.org/packages/27/b8/ca7319556912f68832daa4b81425314857ec08dfccd8dbc8c0f65c992108/kaitaistruct-0.11.tar.gz"
    sha256 "053ee764288e78b8e53acf748e9733268acbd579b8d82a427b1805453625d74b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/03/4f/2750f7f6f025a1507cd3b7218691671eecfd0bbebebe8b39aa0fe1d360b8/pefile-2024.8.26.tar.gz"
    sha256 "3ff6c5d8b43e8c37bb6e6dd5085658d658a7a0bdcd20b6a07b1fcfc1c4e9d632"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/90/a1/d5f9002a70298c64a789779077d8dd90c10aa1f47fe40c86802df874f2a6/platformdirs-4.12.4.tar.gz"
    sha256 "63743c02414e755de4e31b8f68125c1407495b86c5a006e203c01ff8b9924250"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/a3/11/767522582afab1b884d277de0e6e011640cb9d7292a38694b4b1a1df1ae8/pyelftools-0.33.tar.gz"
    sha256 "660d82dcbeb8e83d1702bd97f223f761625da06111c0cc988eac6b8ab0c1b61f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/32/ab/a340c7f529646f16e5656a8ba1424ed0de406203e4554868491786628730/requests_cache-1.3.3.tar.gz"
    sha256 "79b72d5ac5143992d1836ad78f4d8e65666061dd44e220548caab3723089826b"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/33/26/b60cce0211e94bb130e88dbcba87583f61c6ddf386fa6adc10a167461f6a/url_normalize-3.0.1.tar.gz"
    sha256 "1655cd214159d9d47dc37aa6ce993c2149da44fa35cac6bafd90036a4eda3ac3"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  # Although the virtualenv_install_with_resources uses the package resources listed above,
  # pip still needs to fetch the project's chosen build system via the network.
  deny_network_access! [:postinstall]

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/abi3audit sip 2>&1", 1)
    assert_match(/sip: \d+ extensions scanned; \d+ ABI version mismatches and \d+ ABI\s+violations found/, output)
  end
end
