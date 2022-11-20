class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7031eb88670ddce6debdd065845964eedb4e76861cd18173c4c292bf46e91894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1622566470e48ee2ebad364f0e55ef38c15287e7ba32a0684ab8f2e2fa4cb3eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "183fe37e5115b2bbc4de9262ecf3bc3dd826201f45ab09e54c36fc231255fd21"
    sha256 cellar: :any_skip_relocation, ventura:        "1f76cfc33331a7fb3b76b93d7d45b297462f20dd4ad11c0a0c8954425f9535bd"
    sha256 cellar: :any_skip_relocation, monterey:       "eaa33b66b295b5cebfce5bc2466b0b75ce366e486103eb91d049c052d569e650"
    sha256 cellar: :any_skip_relocation, big_sur:        "0830609eb2780349a180dfa53ae9d0cc2c294d0ad963697365b6c0d593245be8"
    sha256 cellar: :any_skip_relocation, catalina:       "22929cf2fb7109b11e718c01178c171bdcf639d390a0b57a133fccfe96ab0369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6653e0c83e9a1725e6c6915fcab0f2237930b19e44dcfc05bebf04435d47f3c9"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
