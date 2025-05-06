class Cloudiscovery < Formula
  include Language::Python::Virtualenv

  desc "Help you discover resources in the cloud environment"
  homepage "https://github.com/Cloud-Architects/cloudiscovery"
  url "https://files.pythonhosted.org/packages/d3/c2/9a5f93ac5376f83903c8550bde45e2888da3fb092b63e02e19d6c852134c/cloudiscovery-2.4.4.tar.gz"
  sha256 "1170ea352a3c7d5643652ebe96b068482734cd995b9c92dc820206f1b87407e5"
  license "Apache-2.0"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "166757c19b4069447bbb1a41e60be7e734d61f845cb0f951fe7410a099a87e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "064a3e7e97a886909f4fb368dcebef7707e3f8ecce081af90e096c01792fd6d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bf4aff37f693f03a1c5487cb10091b711d2da575107da81db51d5cafdce814b"
    sha256 cellar: :any_skip_relocation, sonoma:        "078273ecd102d192d38ded37f8f768467b592302c8b58b7b0d9e5097ee41e158"
    sha256 cellar: :any_skip_relocation, ventura:       "3e3e859e0ad0cfcf0ce7fa5a0063304194345ecb6c47c03c560b35fddb02c41c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3895cb0a39abcd9fdf74f527894fbe09dad23464b0356884abee1ff81f146ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d88b7b392ea5615d256ec973cd48d482570d6a8b6d3fc2f703a72443c042fa3"
  end

  deprecate! date: "2024-10-11", because: :unmaintained

  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b8/29/10988ceaa300ddc628cb899875d85d9998e3da4803226398e002d95b2741/boto3-1.35.39.tar.gz"
    sha256 "670f811c65e3c5fe4ed8c8d69be0b44b1d649e992c0fc16de43816d1188f88f1"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/f7/28/d83dbd69d7015892b53ada4fded79a5bc1b7d77259361eb8302f88c2da81/botocore-1.35.39.tar.gz"
    sha256 "cb7f851933b5ccc2fba4f0a8b846252410aa0efac5bfbe93b82d10801f5f8e90"
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
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
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
