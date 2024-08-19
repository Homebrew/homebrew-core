class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/fd/45/9d082f86318981c254f5c784b0dda9d673cc30f992cc4f6bf69cecb08aec/aiven_client-4.2.1.tar.gz"
  sha256 "456e91afe8e97bc4d0adb6f784888a6f241a3d47bfef4008b2938b9d9a128cb3"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c555d93477f9214d649bd15bda819c9f4cd77cc8fada4e3047cc4957abf77d08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c555d93477f9214d649bd15bda819c9f4cd77cc8fada4e3047cc4957abf77d08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c555d93477f9214d649bd15bda819c9f4cd77cc8fada4e3047cc4957abf77d08"
    sha256 cellar: :any_skip_relocation, sonoma:         "c555d93477f9214d649bd15bda819c9f4cd77cc8fada4e3047cc4957abf77d08"
    sha256 cellar: :any_skip_relocation, ventura:        "c555d93477f9214d649bd15bda819c9f4cd77cc8fada4e3047cc4957abf77d08"
    sha256 cellar: :any_skip_relocation, monterey:       "c555d93477f9214d649bd15bda819c9f4cd77cc8fada4e3047cc4957abf77d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14c976c89d9292fb179899bd6cff643db17ad7dedaa2a9478ae160d5716ff089"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
