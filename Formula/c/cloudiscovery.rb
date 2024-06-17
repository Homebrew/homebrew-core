class Cloudiscovery < Formula
  include Language::Python::Virtualenv

  desc "Help you discover resources in the cloud environment"
  homepage "https://github.com/Cloud-Architects/cloudiscovery"
  url "https://files.pythonhosted.org/packages/d3/c2/9a5f93ac5376f83903c8550bde45e2888da3fb092b63e02e19d6c852134c/cloudiscovery-2.4.4.tar.gz"
  sha256 "1170ea352a3c7d5643652ebe96b068482734cd995b9c92dc820206f1b87407e5"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2f37c041277aa51f88f9706619840a6b7af2419e21e27044fefaa9de241d102"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53e93db4bbe31ce6860f9d78a9bd49220ca15bb6fe8437344c57636b5cd9bbf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe97db5991e37f9da3f889f5985862fddf79179475877e4f5cfc10903e1f15a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a86fa8236f7025652ff70452b5a6388ed5b99e0776b703caf1ba2b0d7dfa5d12"
    sha256 cellar: :any_skip_relocation, ventura:        "ece540be1c729d0a02b4ebe5fcd82d3dc07659fda0fe03c8a9ab7c8fcce6e85b"
    sha256 cellar: :any_skip_relocation, monterey:       "bf87518ddc38327545ccc612f7a53a8d5e7ea37624fa9655d59716908325dc55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7945f55fa50cf8f95a1ba422044e5b9d3e0be3f61f3a34e0a010f520d9f4c4c"
  end

  depends_on "python@3.12"

  # markupsafe needs to pinned to 2.0.1
  # see PR, https://github.com/Homebrew/homebrew-core/pull/151558

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/4b/cd/9331ee4ecdbfd58e268664fc1126e7aa015a31ce088b0c1e3cf48bb56e97/boto3-1.28.66.tar.gz"
    sha256 "38658585791f47cca3fc6aad03838de0136778b533e8c71c6a9590aedc60fbde"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ed/19/489d319b286f629be7c56025dfc0df41e69166eb559996bd07f664b2c63d/botocore-1.31.66.tar.gz"
    sha256 "70e94a5f9bd46b26b63a41fb441ad35f2ae8862ad9d90765b6fa31ccc02c0a19"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "diagrams" do
    url "https://files.pythonhosted.org/packages/1b/ee/3070e64c5e468d1f3a0a04c2863cff633b2263b33265a82df1f1e8c82a36/diagrams-0.23.3.tar.gz"
    sha256 "543c707c36a2c896dfdf8f23e993a9c7ae48bb1a667f6baf19151eb98e57a134"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/a5/90/fb047ce95c1eadde6ae78b3fca6a598b4c307277d4f8175d12b18b8f7321/graphviz-0.20.1.zip"
    sha256 "8c58f14adaa3b947daf26c19bc1e98c4e0702cdc31cf99153e6f06904d492bf8"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9/ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/f9/7e/a424029f350aa8078b75fd0d360a787a273ca753a678d1104c5fa4f3072a/typed_ast-1.5.5.tar.gz"
    sha256 "94282f7a354f36ef5dbce0ef3467ebf6a258e370ab33d5b40c249fa996e590dd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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
