class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/8e/9a/64e0e24972057276141403b5971e87d8f51c82ba3d027badc10f39e5524f/parliament-1.6.2.tar.gz"
  sha256 "05f9db2bda8d85f039dbe27716538f025b7cb973d336568762a06217e3b7e3ae"
  license "BSD-3-Clause"
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "793aaf3ec629b551aef846cf197c6eed1333b11bdf77b87849f665daa4ece393"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deebfe54315a56ed439cf8c65b3b1adae33aa1fbf3c4f39b4cf14caf5313401f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "249f3257fbc3aa941a84be43b1c6feaede1eb6a47eed1005c958bd7c4409f4a0"
    sha256 cellar: :any_skip_relocation, ventura:        "3d62c6315016bfce9e2b866b8668d275bab7fe1d6c5fb57eaac49e836af5a971"
    sha256 cellar: :any_skip_relocation, monterey:       "67a3074ef1ab056322eb9c205fe698dbc0fcecdb79d787c6e6565f8de30d0403"
    sha256 cellar: :any_skip_relocation, big_sur:        "530a75b7270e1132fed8dab200c248b05b523acf274dd9e0f283804c413552b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e5aa8d443888fe5c664cc1e2859877c9cba2b60bb13fd5641f872799c4760fd"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/59/10/5069c80e6d9e3c4d72c3396d62831710c8f0e944c86e306a8212c12d469e/boto3-1.27.1.tar.gz"
    sha256 "cf43deb4556295219d9de44d1c95921209c90ee25246673b5768aef9d46519cc"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/24/57/ee9a4b122f697477bf4d0d9f0dc7951a494937cf78f4321a6c5d3d71d99e/botocore-1.30.1.tar.gz"
    sha256 "4d1ac5a796c5c5c87946f25f3d98764288a0ed848e772a7a47cd134847e885e7"
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

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
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
