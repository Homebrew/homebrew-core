class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/8b/91/fe6ef857eea3a6794883dc5c767dbaf9eeba452b0759ee88659fece0699e/parliament-1.6.1.tar.gz"
  sha256 "39c854dcf5c35c02366cfea531078f585bd6a6183248f792874588c8c48feca3"
  license "BSD-3-Clause"
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d1a007e440c4a05547d8e71e9b0784150c8f1ff423b097812535deb0f98c2c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "084335ad41b5c41f03d257666820cd8a4df31f67ab54e7629215a928286aeeab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99df83d72b24d57320e75dad3de07a6787fc9e7b4292899c3da93715d6687b11"
    sha256 cellar: :any_skip_relocation, ventura:        "34079d2c687af4a481712cad543e52f6d18ecd60a19d9bab117be228560e4c5a"
    sha256 cellar: :any_skip_relocation, monterey:       "f14798318df7aee9f382e0f495aa19023eb8f68d59df1f0a887aaf8d09e0d237"
    sha256 cellar: :any_skip_relocation, big_sur:        "26ebb19e82b2d7fb5baaf77743e972a15a473d924def8001b60673e969a5ebe5"
    sha256 cellar: :any_skip_relocation, catalina:       "0efbf4eeeb931fb3c3b003f47706301ceee50bb3076f68eb5e44035dca8d2bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff77db0608241abe9505b4c7fdc9f76beb547948828184b3e9e725b242585fa8"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/9e/a2/10f0d67f71bf6f87b2dc6558679f23c0cb4c3be42089a7eef625ed35d002/boto3-1.26.8.tar.gz"
    sha256 "b39303fdda9b5d77a152e3ec9f264ae318ccdaa853eaf694626dc335464ded98"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9c/62/0e7a8c2bc63c3529db0ca3ee4c0f5b60a65165e594d1487b13b6524ddccd/botocore-1.29.8.tar.gz"
    sha256 "48cf33d7c513320711321c3b303b0c9810b23e15fa03424f7323883e4ce6cef8"
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
                 "'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}",
    pipe_output("#{bin}/parliament --string '{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}'").strip
  end
end
