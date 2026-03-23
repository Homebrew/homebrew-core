class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  # Restore PyPI URL and remove livecheck after https://github.com/trek10inc/awsume/issues/289
  url "https://github.com/trek10inc/awsume/archive/refs/tags/4.5.5.tar.gz"
  sha256 "33946d1dbd62394024b1d11c09aeb1eb566981b99e0d8eed5255b948e74ccebc"
  license "MIT"
  head "https://github.com/trek10inc/awsume.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "976bf1db3acba0316e4b91cb969a43f91ee6d97d59fd4b80e2678dde6a3f1b94"
    sha256 cellar: :any,                 arm64_sequoia: "9e2c00c7eb4ed65385a540db0a602839b9671d84b70b80f2c3b03f62c54858fc"
    sha256 cellar: :any,                 arm64_sonoma:  "5529de9a81df8487da268896213867e7cf9a7c38d3f1569035ec3c02fd2dbdb9"
    sha256 cellar: :any,                 sonoma:        "b3e6d65c0cb235b6c26ca9e18db41cd8d327868540d9afa69f33ac7482a3de27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5764c35d4ca67bebd15db99ad96b47f0258913edf35fb27deff7b7bf8aac2c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f8fdaa0cab57c9d58823ac01c345c4e2d4703c7ebafb0abed215c3202d8b09b"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "sqlite"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/d0/69/c0d4cc77add3cdf66f8573555d71dc23ba32dfe77df40e1c91385f7a9bdc/boto3-1.42.34.tar.gz"
    sha256 "75d7443c81a029283442fad138629be1eefaa3e6d430c28118a0f4cdbd57855d"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/fd/f0/5702b704844e8920e01ce865cde0da574827163fbd7c0207d351ff6eea2c/botocore-1.42.34.tar.gz"
    sha256 "92e44747da7890270d8dcc494ecc61fc315438440c55e00dc37a57d402b1bb66"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("bash -c '. #{bin}/awsume -v 2>&1'")
    assert_match <<~YAML, (testpath/".awsume/config.yaml").read
      colors: true
      fuzzy-match: false
      role-duration: 0
    YAML
    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  PARTITION  ACCOUNT",
                 shell_output("bash -c '. #{bin}/awsume --list-profiles 2>&1'")
  end
end
