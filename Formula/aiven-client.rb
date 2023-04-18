class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/d4/85/cf96c822d14517b65bed9928c594cfb9d87b5eafe42ffe45d4ef39f21093/aiven_client-2.19.0.tar.gz"
  sha256 "167dc3da4e52de0de22fa088baaf025360f68d3aaff26155b55e7f16e46c791f"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce354e85c6f7f6d1de5370ff5c2f4002a33745a61c0698c347693c4d50087b9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b37d5dfa7d3763ffcf1ef8b11c0ce69ca4269737ca0a8121bae19292b7bcbc94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd9e293b9dd3d2c482642b7dacd41fa4509ebe674fb06242f5a51767dd76ba29"
    sha256 cellar: :any_skip_relocation, ventura:        "be7b7aed8f3db4a8503b7ec21ca6f96e5e19b23788d5f26700ef44db4f126f5f"
    sha256 cellar: :any_skip_relocation, monterey:       "6d72e266b15812c48f951673224c4f2ef90370f0a98cc6dc00476e362366363f"
    sha256 cellar: :any_skip_relocation, big_sur:        "91d7c373fb675d2d8c74a9416a5eb3deb69299f6fd3eb786a2bfebcaf1eaadee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13d9062d25342099f1f87ab92c85e1b0c899c6f3b7be09997ae506c68f5d6e03"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
