class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/a6/12/92bbf5db0eac6d901ccca51f001b64a4a57f8b06d7189147cd3c9ee570ce/parliament-1.6.4.tar.gz"
  sha256 "ea6b930de2afd2f1591d5624b56b8c9361e746c76ce50a9586cab209054dfa4c"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e126f09f60411c3901372282eb6a3c0f0229259c1fe3228037ca7fba59ec9f5"
    sha256 cellar: :any,                 arm64_sequoia: "c9437d13deb7399b11ad58d72327ca6eedf90e392a70807f219af1f8d4ea6665"
    sha256 cellar: :any,                 arm64_sonoma:  "39af639a0190f7f8dbaa85e127ce217f67bef5fee7102ad1f5870cafe81ec459"
    sha256 cellar: :any,                 sonoma:        "607e3ec65e1fe812f1cb02bdf9df97260ab2335a44aaacd9fcf34a5a3047d37f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ba7891730446142ac564711fd72d04d4cebf3a32ccf167d428630854b8f0b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6b648d29868d087d175355b0e33738d90fa95e01c0390f9891c594694fa11a2"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages extra_packages: "setuptools"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/29/30/755a6c4b27ad4effefa9e407f84c6f0a69f75a21c0090beb25022dfcfd3f/boto3-1.42.25.tar.gz"
    sha256 "ccb5e757dd62698d25766cc54cf5c47bea43287efa59c93cf1df8c8fbc26eeda"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2c/b5/8f961c65898deb5417c9e9e908ea6c4d2fe8bb52ff04e552f679c88ed2ce/botocore-1.42.25.tar.gz"
    sha256 "7ae79d1f77d3771e83e4dd46bce43166a1ba85d58a49cffe4c4a721418616054"
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

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject', " \
                 "'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}",
    pipe_output("#{bin}/parliament --string '{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}'").strip
  end
end
