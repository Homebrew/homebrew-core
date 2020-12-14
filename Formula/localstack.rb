class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://github.com/localstack/localstack"
  url "https://files.pythonhosted.org/packages/47/6a/98c58efc414af91b0f2b9827206acf1e33fd65122e2f6875301d09262f8e/localstack-0.12.3.tar.gz"
  sha256 "f2d3fa98d884ef94ffceb8b0ec4e166686732fdcc60bc4bffcf113fb3f224aa9"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5584746779f239b71bfbe205ce1162b40feb54c809475f3dbeb6bf391dd6a488" => :big_sur
    sha256 "74aed43383f80f36cd2f1b630ec34ed22a305f2a9a162fbc94f12aa69354ff2e" => :catalina
    sha256 "e3fd19b94ad3c41a7288d552dde33538cd9f4e41882b4ba4777f8a6b8ecbdbcb" => :mojave
    sha256 "1ecec6176791abf38cc78e09b27f5dbdc48bd8b8e2b1f92ca09a5f8e6d25d47d" => :high_sierra
  end

  depends_on "docker" => :test
  depends_on "python@3.9"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/16/ed/205f4ac5e3d017cb261f96ff98b0ff7d311d2688f3484afaa2720ddda119/boto3-1.16.35.tar.gz"
    sha256 "a35e0915547ea659ddd832c9aaf55038c56fa894c4cc2a2a46cd6c642494012a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/82/86/f0c0cd4a3b442464babf1feaa3325e2ff7eaddae293f628c181af81e9151/botocore-1.19.35.tar.gz"
    sha256 "633aa910509b060717df4130f7e2841f1101c0c47fd5871f4903b4b1dbab7e23"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
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
    url "https://files.pythonhosted.org/packages/d3/41/1468bc8fce2b2abff02dbd26bd043c46c1a900c13f8be8c297ff3fbc4110/localstack-client-1.10.tar.gz"
    sha256 "1b9fa8c61f1bcc9d3e5b0fb8d7fe553f2e59f19ec5238eadc8f65af733497729"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/a5/6b/f02ef1c4b3f072c1d868d656b11cd11b82256846fd1fc5a98cbe15f8d237/localstack-ext-0.12.1.3.tar.gz"
    sha256 "78d8de385ef7e81cbbd64ee4b6d1eac73fd7961965df0352cf150d8e674465b5"
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
    url "https://files.pythonhosted.org/packages/9f/14/4a6542a078773957aa83101336375c9597e6fe5889d20abda9c38f9f3ff2/requests-2.25.0.tar.gz"
    sha256 "7f1a0b932f4a60a1a65caa4263921bb7d9ee911957e0ae4a23a6dd08185ad5f8"
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
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
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
