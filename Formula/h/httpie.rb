class Httpie < Formula
  include Language::Python::Virtualenv

  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https://httpie.io/"
  url "https://github.com/httpie/cli/archive/refs/tags/3.2.4.tar.gz"
  sha256 "b185cd8d81325f97c773582e50f1c5e047c2d8575b53d676469c9daf2a52f341"
  license "BSD-3-Clause"
  revision 12
  head "https://github.com/httpie/cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2f7cc5d09d7467cdf548981d6372f79f9cd7e546d9c0b2e60a16fcc5d6e6545"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "783fc4a871555c5a5e1c976a8b8bdb5161b8a30f821db100ed6d040751f4f1b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2dd86a488c6fc075780d3911e4caa7533364e2fb373240570bc3ce88259be6a2"
    sha256 cellar: :any,                 arm64_linux:       "a47b5ae577c9bf168f6f632615c90adc27841a718c216189ff7e97a6c0183459"
    sha256 cellar: :any,                 x86_64_linux:      "4956b24e6d5a3915540b8df53c4da2d3b78e8284012a249a0232c214aca03661"
  end

  depends_on "certifi"
  depends_on "python@3.15"

  pypi_packages package_name:     "httpie",
                exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/c4/64/642465a4827331a98ba4ae29f97658be25d1bdcb868872a2f78f7482b507/multidict-7.0.0.tar.gz"
    sha256 "a7fcd089a0af2e0ef053c0d39c22c9ebf2434dddcb91034fd2f59ec99623788e"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    # We use a special file called __build_channel__.py to denote which source
    # was used to install httpie.
    File.write("httpie/internal/__build_channel__.py", 'BUILD_CHANNEL = "homebrew"')

    virtualenv_install_with_resources

    bash_completion.install "extras/httpie-completion.bash" => "httpie"
    fish_completion.install "extras/httpie-completion.fish" => "httpie.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/httpie --version")
    assert_match version.to_s, shell_output("#{bin}/https --version")
    assert_match version.to_s, shell_output("#{bin}/http --version")

    raw_url = "https://raw.githubusercontent.com/Homebrew/homebrew-core/HEAD/Formula/h/httpie.rb"
    assert_match "PYTHONPATH", shell_output("#{bin}/http --ignore-stdin #{raw_url}")
  end
end
