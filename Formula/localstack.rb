class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://github.com/localstack/localstack"
  url "https://files.pythonhosted.org/packages/15/5e/eda186199d8033caf286599d40fa04a7939c07b2c1bd0426ad1887429dc6/localstack-0.12.8.tar.gz"
  sha256 "8a038785f6a9d0743ba5bd1a80de8adf8b81b5de0d6ee8b6d7672fb3c201f470"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e636bd22526ed36e8e563a1a75d16fc5b9e954b1a6a882e401ae4aa1b07b0026"
    sha256 cellar: :any_skip_relocation, big_sur:       "916346de0868f3194c0352f336768c3654cf6d4a25afff614b8234f19957ad42"
    sha256 cellar: :any_skip_relocation, catalina:      "66eb4850e657abae010578518d67a5fdbedbe4479845c1ae9838cfd9b93919ba"
    sha256 cellar: :any_skip_relocation, mojave:        "dfa77e9c7f0b4c6791741286ea6b14a2a6a3a6e8e93e0451eb90185e2f9f0c98"
  end

  depends_on "docker" => :test
  depends_on "python@3.9"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/03/e1/8a4e2ed00dbbeec3cd69ac8a91ce4183c278ecd3ce3c80322212afb9de95/boto3-1.17.39.tar.gz"
    sha256 "b5814ff73b5b8fc8601c1b73b70675807f9ce64713562e183a08415a2516eed4"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9a/93/86694d0bd25bea4a2dc0f7e672036fe13c1dd1f9cde1bd3ff66f3dc74d6e/botocore-1.20.39.tar.gz"
    sha256 "28506d23ffa9abf5666c2c909c7edc83a1112cd44fe74eb1a4960df561531e98"
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

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/31/02/791c17b92e6d04c43f9b318c95a3f3c3e1ea718aa72ad95b9dac147895fa/dulwich-0.20.21.tar.gz"
    sha256 "ac764c9a9b80fa61afe3404d5270c5060aa57f7f087b11a95395d3b76f3b71fd"
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
    url "https://files.pythonhosted.org/packages/bb/74/83fa8b0750addd59f8d40ebd8c919466975011476746af132c2e8756942e/localstack-client-1.14.tar.gz"
    sha256 "dcfe0258d076d654c8b8ffd14a0783216ed7eb0567e66313928beab03966e549"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/77/93/b53378f13410694311a0e81ad459fff88978eacc79d5f6dc626545dc2aed/localstack-ext-0.12.6.4.tar.gz"
    sha256 "fe3e0f239e610a278666592c9bb580788f2460854fa732b994dff351d9775d1e"
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
    url "https://files.pythonhosted.org/packages/0f/c2/266326b601256b5722aea10961504857f324cd50f4adc66a2f573fbea017/s3transfer-0.3.6.tar.gz"
    sha256 "c5dadf598762899d8cfaecf68eba649cd25b0ce93b6c954b156aaa3eed160547"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
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
