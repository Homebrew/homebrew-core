class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/cd/b6/08bc0bf3cf2cf0d7b08442d4d2bcf2d94144db7e22f0d4aa5621789c0e15/detect_secrets-1.2.0.tar.gz"
  sha256 "c160e897b3d0e81bf9cf0f6cc2e5e6434fa609a159f9a2849fcae0a08b4e2a30"
  license "Apache-2.0"
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "c4a8923080d7b896ac352b5c13cbc18c0dd74cc56a6452e3d0bbcc759e12dad0"
    sha256 cellar: :any, arm64_big_sur:  "26c83f1239a9a4232991e8c2ac0d7aa5f2657409d647f020a549cf83af96032b"
    sha256 cellar: :any, monterey:       "78f1edcf6f4907ca46695709c13a46c58bd46098644c6ccf533fd0b3dd9edbd9"
    sha256 cellar: :any, big_sur:        "1803df0d2f14fa8eb852f84b1ccf5e7e22da6219f001d1ec5cf617d42c3a095d"
    sha256 cellar: :any, catalina:       "41e50c5f13445c03b7e3d4f0c97d357c5886011d5fc2dcc8a93e89e387a14345"
    sha256 cellar: :any, mojave:         "5feaab84d7f0c91d3453f93c019abf3abd5ec04c66d22798925ecd0b27baeeb9"
  end

  depends_on "libyaml"
  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
