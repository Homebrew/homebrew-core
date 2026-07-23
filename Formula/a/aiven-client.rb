class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/db/29/a1999da4d4ad1c5ab22f8c818af266d9f20427dad2f12ba045735594b106/aiven_client-4.16.0.tar.gz"
  sha256 "469f9b9f73761dabe2ab7b8d70a593c6ace2a4a3c47fcf0a44a6e308cc813ccb"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8fcd05c5dced53c5c4ef5031552a201096b1df907aead5b60c8fdd1aed3ab2cf"
  end

  depends_on "certifi"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", shell_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1", 1)
  end
end
