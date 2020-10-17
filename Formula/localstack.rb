class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://github.com/localstack/localstack"
  url "https://files.pythonhosted.org/packages/28/6d/f477a7fd3db56c01a507303caa9fb1529ea4524d178db9bd56ecf4470896/localstack-0.12.0.tar.gz"
  sha256 "1bc74efe61254e81a00a79f12f00d65e996604f5d076b4c95db56c5a04639ad9"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "de27d61ff6e9b3c72321ce96151ac7c3688adfab0bd312a01548504b787b3324" => :catalina
    sha256 "391853de2eea78e363d0509f791534b47bf32be3ef602d848588da30548e1718" => :mojave
    sha256 "6786aed621545da75340485f36032ac038f3f04155c9c61d1fcf0616abec7e0d" => :high_sierra
  end

  depends_on "docker" => :test
  depends_on "python@3.9"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ce/b8/e7fa00e5de96229964b16e766e20bbde0e055a97fc475cef7deba9036593/boto3-1.15.18.tar.gz"
    sha256 "f56148e2c6b9a2d704218da42f07d72f00270bfddb13bc1bdea20d3327daa51e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/02/af/2fccd3e251e406429ef433f1cf1fed24da0fa527c7604db757e219aa2bbc/botocore-1.18.18.tar.gz"
    sha256 "e224754230e7e015836ba20037cac6321e8e2ce9b8627c14d579fcb37249decd"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "dnslib" do
    url "https://files.pythonhosted.org/packages/07/ec/611036f948b362e1155e68521c2e8f589f919b51fa361157e8808faffbe3/dnslib-0.9.14.tar.gz"
    sha256 "fbd20a7cd704836923be8e130f0da6c3d840f14ac04590fae420a41d1f1be6fb"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ec/c5/14bcd63cb6d06092a004793399ec395405edf97c2301dfdc146dfbd5beed/dnspython-1.16.0.zip"
    sha256 "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/0a/7a/1806e8f23884871edcc34253940024d9a10d2596cbe0479d026693a780bc/localstack-client-1.5.tar.gz"
    sha256 "2c45f23f4dccd76f1b5c05830580edef475a55c3cc86d51cb067e2111c86be36"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/2b/08/6080525a177319a416ba44bf113cb42329249fde49da83e68ac7512a00e2/localstack-ext-0.11.43.tar.gz"
    sha256 "7f462e07a02c2a25e51cb1143d0b866d1f75fe11b5c89911c54c166fba72257e"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/50/de/2b688c062107942486c81a739383b1432a72717d9a85a6a1a692f003c70c/s3transfer-0.3.3.tar.gz"
    sha256 "921a37e2aefc64145e7b73d50c71bb4f26f46e4c9f414dc648c6245ff92cf7db"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["DOCKER_HOST"] = "unix://" + (testpath/"invalid.sock")

    assert_match version.to_s, shell_output("#{bin}/localstack --version")

    output = shell_output("#{bin}/localstack start --docker", 125)

    assert_match "Starting local dev environment", output
    assert_match "Cannot connect to the Docker daemon", output
  end
end
