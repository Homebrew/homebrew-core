class Cloudiscovery < Formula
  include Language::Python::Virtualenv

  desc "Help you discover resources in the cloud environment"
  homepage "https://github.com/Cloud-Architects/cloudiscovery"
  url "https://files.pythonhosted.org/packages/d3/c2/9a5f93ac5376f83903c8550bde45e2888da3fb092b63e02e19d6c852134c/cloudiscovery-2.4.4.tar.gz"
  sha256 "1170ea352a3c7d5643652ebe96b068482734cd995b9c92dc820206f1b87407e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87f23d3b535a5f2905bd8a2d04d03ea8a1354cf46a9bad2f960d3870cf5d730e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f0e54433a4e9189761a6b5612ec77eb3f3f09191f94f81cf9661795ad6eb2ef"
    sha256 cellar: :any_skip_relocation, monterey:       "41635d2c7251cf9a027158e64cf845c089a4ac4d1907121d88e8d0db9deac497"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2c1720f3e99c148e387b91114faf4e4dacca3598356a7483ece939228e04dfb"
    sha256 cellar: :any_skip_relocation, catalina:       "ef172c7675f1107f12560728cae72fca39f1913f5f8628681dc693a1fa333dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07856bd03ec586bdaef2d56cbbda9a34819a349857d219978074daa1979d18f1"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/d9/91/1dc0a7d0ac74366d86d1860f7f9ffd9f6f80a01e0c2b798412fafcc548bb/boto3-1.19.3.tar.gz"
    sha256 "e36ffaf9969648e2f435aa1f0029956fea3aac52466eef3bcb43bde498a182dd"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c4/80/887bf75741359a3b067b7cf6cf1c426e503e9d1130c6fd0cb5b2c4b08123/botocore-1.22.3.tar.gz"
    sha256 "53ca22aeac9b53fe5ec1f40b8ca9620ffe8b054458abfeb9ab74bbe9e0b0ecfa"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/d7/69/c457a860456cbf80ecc2e44ed4c201b49ec7ad124d769b71f6d0a7935dca/cachetools-4.2.4.tar.gz"
    sha256 "89ea6f1b638d5a73a4f9226be57ac5e4f399d22770b92355f92dcb0f7f001693"
  end

  resource "diagrams" do
    url "https://files.pythonhosted.org/packages/3c/17/297c20150513547fc2bad08e96ca4efbbfdfe90affb232f0c4b89570fff0/diagrams-0.20.0.tar.gz"
    sha256 "a50743ed9274e194e7898820f69aa12868ae217003580ef9e7d0285132c9674a"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/49/07/079b8b4eb2aba194fca4562c7f014ea45a40130ebff539628c05c52d9050/diskcache-5.2.1.tar.gz"
    sha256 "1805acd5868ac10ad547208951a1190a0ab7bbff4e70f9a07cde4dbdfaa69f64"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/cc/a3/8f49063fee2037892f66f1a4d55da8ba25235e76dc27887f7edf95272154/graphviz-0.16.zip"
    sha256 "d2d25af1c199cad567ce4806f0449cb74eb30cf451fd7597251e1da099ac6e57"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9/ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{aws-vpc,aws-iot,aws-policy,aws-all,aws-limit,aws-security}",
      shell_output(bin/"cloudiscovery --help 2>&1")

    assert_match "Neither region parameter nor region config were passed",
      shell_output(bin/"cloudiscovery aws-vpc --vpc-id vpc-123 2>&1")
  end
end
