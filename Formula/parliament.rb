class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/80/30/f36a5c2c6eb25d49e515ef846082cb0496afecf8d7962b7c261f8303738b/parliament-1.6.0.tar.gz"
  sha256 "f44c63e7934d5c78c2628066aab1b6044f067afd7a32be4bc64fb1ee814ec575"
  license "BSD-3-Clause"
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "333d2e3d3efdf8b87f9c0fe9fa2d03081256afad546880b459123e00aa4d1f6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5323fb61cea69c3c06af5b6b65e7e3176b724b4c0feb603fd1797a681ef9a042"
    sha256 cellar: :any_skip_relocation, monterey:       "3ec93ebd9de4c765ffdca0d96fd3d8bdf7df372ea4eb4e073d5f416153d5c8c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0adaa6db71638d44fdc5879feb17e748a0bba14138b61804e32cdf52e74ac3ef"
    sha256 cellar: :any_skip_relocation, catalina:       "82a8834f0e2692caa13738729dbf6f476a494ddb065e416c65d224523bed661f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d68a0e002aeb5bd42edd23fb04247a6567926b1bc5356c65168d11929e323d2e"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a4/d5/28947cd78711ead30a109b0d31602e6fd9efa38f1c2b7903af139b898965/boto3-1.24.66.tar.gz"
    sha256 "60003d2b83268a303cf61b78a0b59ebe2abe87e2f21308b55a99f25fd9bca4db"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0d/72/3e94737e6eeb2f760e57fce15498a8d43c4c0939b35ce576310de9a9713a/botocore-1.27.66.tar.gz"
    sha256 "6c8c8c82b38ba2353bd3bc071019ab44d8a160b9d17f3ab166f0ceaf1ca38c12"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "json-cfg" do
    url "https://files.pythonhosted.org/packages/70/d8/34e37fb051be7c3b143bdb3cc5827cb52e60ee1014f4f18a190bb0237759/json-cfg-0.4.2.tar.gz"
    sha256 "d3dd1ab30b16a3bb249b6eb35fcc42198f9656f33127e36a3fadb5e37f50d45b"
  end

  resource "kwonly-args" do
    url "https://files.pythonhosted.org/packages/ee/da/a7ba4f2153a536a895a9d29a222ee0f138d617862f9b982bd4ae33714308/kwonly-args-1.0.10.tar.gz"
    sha256 "59c85e1fa626c0ead5438b64f10b53dda2459e0042ea24258c9dc2115979a598"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject', " \
                 "'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}", \
    pipe_output("#{bin}/parliament --string \'{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}\'").strip
  end
end
