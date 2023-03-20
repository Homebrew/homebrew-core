class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/cd/67/24c15ed8a4164a0c0f53b314a2024b82350be430fdf4c6d15e64d7a3b761/aiven-client-2.18.0.tar.gz"
  sha256 "6c3361250fba90f679bf35c2d34e7d952355a614d321078c13443a47b0237d3b"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36505cd0ec09fad6c224ac9423477e12bc5ac5968afe716f8c522709a5c75bec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b33d55acfa430417c5f60fb071ac2ba67e4229b2c4458781ba9de51d08364a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a56a8300fc654ebba93d4fa8b52cd597b8acbf369753008117adf3052b6b4b80"
    sha256 cellar: :any_skip_relocation, ventura:        "0d4887f17b7ebaa172d61aaaf34c4d467985705e3485c99a66e77c67ea7ce8fe"
    sha256 cellar: :any_skip_relocation, monterey:       "7b6089b99528c0a55169b4e2d941d6610c308b663acf408c3bd19a1b6ac3db1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "01caefe620f3ec23be6a20bd8a901a2167c56ea83d6039cf180aef9bcc32b2eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304d7f6618163e5b44456a54583c982bdceca9c3baffed22cb597a952dd894c4"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
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
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
