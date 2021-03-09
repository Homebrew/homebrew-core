class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://github.com/localstack/localstack"
  url "https://files.pythonhosted.org/packages/eb/6c/dd5941abd66171fc9b36dbdd76623971b1c7f33dcf4468270d30c4b6585c/localstack-0.12.6.1.tar.gz"
  sha256 "d83fbfce9c1a50cd69bf5496868807688afef038547c4c9fa1fe9da412800f7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "19e788ab5dc79ee095fb0e76bf11b5b5520ecc8f06548893f58c7543d96d0589"
    sha256 cellar: :any_skip_relocation, big_sur:       "33f286ba5d453221795473a3eee0a287ac833972e6b69f138310807da43b534f"
    sha256 cellar: :any_skip_relocation, catalina:      "ca840c4025ed0180445f2ab9165b478e6e9371e360653f404c6d69290f346130"
    sha256 cellar: :any_skip_relocation, mojave:        "2b8ab1ad918db057cd3cac74f8cf4e3935e6d6605ddb3dab1513149649c74507"
  end

  depends_on "docker" => :test
  depends_on "python@3.9"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a0/fd/2363c1f527c30ec14922f55f1cd65694f92100ba9546c4522c7cd5fed609/boto3-1.17.3.tar.gz"
    sha256 "9f132c34e20110dea019293c89cede49b0a56be615b3e1debf98390ed9f1f7b9"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/10/37/91ef27d73f4611ea2c0d3c1cafb33a7fa4d6b5ccdf46c6e135d1fa6c8fc0/botocore-1.20.3.tar.gz"
    sha256 "a0fdded1c9636899ab273f50bf123f79b91439a8c282b5face8b5f4a48b493cb"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
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
    url "https://files.pythonhosted.org/packages/e5/1a/e7557feffabb046257a46b2ad5e86e77adf445fb1c71005573df4373634a/localstack-client-1.12.tar.gz"
    sha256 "c09ffa29dc546aaa5fd049b0fd3542e21a952ae9959470fcc4fec55f10c41cff"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/6a/95/a9645f759ffb7ab7b5ec595d1f97f76b36272d4b2281acb3adb0914aa818/localstack-ext-0.12.5.3.tar.gz"
    sha256 "2b2d2ac1e18fa591e170e3aa996cf9aa56f1fcce1b3b0cec116b5901f55321d7"
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
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/08/e1/3ee2096ebaeeb8c186d20ed16c8faf4a503913e5c9a0e14cd6b8ffc405a3/s3transfer-0.3.4.tar.gz"
    sha256 "7fdddb4f22275cf1d32129e21f056337fd2a80b6ccef1664528145b72c49e6d2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d7/8d/7ee68c6b48e1ec8d41198f694ecdc15f7596356f2ff8e6b1420300cf5db3/urllib3-1.26.3.tar.gz"
    sha256 "de3eedaad74a2683334e282005cd8d7f22f4d55fa690a2a1020a416cb0a47e73"
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
