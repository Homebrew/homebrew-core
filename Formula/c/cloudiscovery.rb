class Cloudiscovery < Formula
  include Language::Python::Virtualenv

  desc "Help you discover resources in the cloud environment"
  homepage "https://github.com/Cloud-Architects/cloudiscovery"
  url "https://files.pythonhosted.org/packages/d3/c2/9a5f93ac5376f83903c8550bde45e2888da3fb092b63e02e19d6c852134c/cloudiscovery-2.4.4.tar.gz"
  sha256 "1170ea352a3c7d5643652ebe96b068482734cd995b9c92dc820206f1b87407e5"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "39af9c9226b1c243584050b82916e01469fca154da540e8aa849f15cb6eb8d68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81d891341180b4dcb85a30cd7c0210a17263516b1ff712b7b4f8576b7e5b652d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dfc0d0262812d711e53042fe71eee446d090d76160ce7a8fcc8f15bbc2a281f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25ed7fbaf11794c40edb655c16a888ad36fb7120b22ffd4873e5f1f07e1b69b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5acbddb988c65c1a7cd71960454a45a60018cdf78fe2a0e91f36e81abba4fa13"
    sha256 cellar: :any_skip_relocation, ventura:        "fa87d3fc3b0f671b20324099d8c7b64272ffc5461d408d6264073eeda3130c2c"
    sha256 cellar: :any_skip_relocation, monterey:       "52b4b49e323afbe22ad2bbabacd39a27591479decef14ce2d58c1638e131905f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c41b9b382bbc614120e6525094dc5b0958806e31f51d3c46e6aa2317dd8f791"
  end

  depends_on "python@3.13"

  # markupsafe needs to pinned to 2.0.1
  # see PR, https://github.com/Homebrew/homebrew-core/pull/151558

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/80/8b/31845869fb935b93d1f1a846d2a8e13dc91af4cf03ba701e2068c08b99af/boto3-1.35.37.tar.gz"
    sha256 "470d981583885859fed2fd1c185eeb01cc03e60272d499bafe41b12625b158c8"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/57/a4/bc96ba621c869f723ce4cb4dadb53fdbb821d64ef1146f0749098ef342cf/botocore-1.35.37.tar.gz"
    sha256 "b2b4d29bafd95b698344f2f0577bb67064adbf1735d8a0e3c7473daa59c23ba6"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c3/38/a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7/cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "diagrams" do
    url "https://files.pythonhosted.org/packages/42/61/44cc86725be481d87c7f35de39cdc21e57ad38dca90d81a2dd14a166ecd2/diagrams-0.23.4.tar.gz"
    sha256 "b7ada0b119b5189dd021b1dc1467fad3704737452bb18b1e06d05e4d1fa48ed7"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/fa/83/5a40d19b8347f017e417710907f824915fba411a9befd092e52746b63e9f/graphviz-0.20.3.zip"
    sha256 "09d6bc81e6a9fa392e7ba52135a9d49f1ed62526f96499325930e87ca1b5925d"
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
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/a8/e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2/s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/f9/7e/a424029f350aa8078b75fd0d360a787a273ca753a678d1104c5fa4f3072a/typed_ast-1.5.5.tar.gz"
    sha256 "94282f7a354f36ef5dbce0ef3467ebf6a258e370ab33d5b40c249fa996e590dd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  # drop setuptools dep, upstream pr ref, https://github.com/Cloud-Architects/cloudiscovery/pull/192
  patch do
    url "https://github.com/Cloud-Architects/cloudiscovery/commit/905c1dc15812000dc7ed2beb9d5193bd6bbe6131.patch?full_index=1"
    sha256 "7a75658504faa46ad9c5424a836d7a1df25e56b64bec88d57ccddf7c06025d5d"
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
