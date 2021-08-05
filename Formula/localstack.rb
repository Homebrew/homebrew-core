class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://github.com/localstack/localstack"
  url "https://files.pythonhosted.org/packages/81/b1/74dc16948f18a192679551d960b6a936ec838b1bac827c2aebf7f6eca7a3/localstack-0.12.16.tar.gz"
  sha256 "af415a2912e8c41f3bd24931f23d0f149ae0ee044612be77b635496eb033c069"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "99ee40ce38d342ad1b86fbbb4655f4e40572c41456b0dda4681317e18f2ef1d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "597cee36cbb9470516e6769ddd4ffc8d5d92efcbd142037539d01faaee6b57ae"
    sha256 cellar: :any_skip_relocation, catalina:      "d919025f66b72a65154c191ea29efe17f05c78992f056598457d101e70f0cf20"
    sha256 cellar: :any_skip_relocation, mojave:        "54ed9f27eb706b9607f3a319a2f15916da750206e199d4fe31b6c0936deaa938"
  end

  depends_on "docker" => :test
  depends_on "python@3.9"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f0/53/f8e9ac6051fa0f5ad4a397198572cc3eb4157cf1b4cc98b6edf52928b0d7/boto3-1.18.11.tar.gz"
    sha256 "ca675c724fa0fe05e992a7146cc5e1a3b3262c4323c83c7a8fcc69f9e5e47f8b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b2/1b/a6f79cf60b3f0317eba52ab0d766250f8ac8c9a35314168dacb5df6dac99/botocore-1.21.11.tar.gz"
    sha256 "b5e9128a259fc0fe5a8c2b717f5d7e8a1321321981b5d5679939e12d4142c0f3"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "dnslib" do
    url "https://files.pythonhosted.org/packages/46/fa/8aa9993017d381cff0908ef72c0e339733709e167557fbfb73eec4c2c9ed/dnslib-0.9.16.tar.gz"
    sha256 "2d66b43d563d60c469117c8cb615843e7d05bf8fb2e6cb00a637281d26b7ec7d"
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
    url "https://files.pythonhosted.org/packages/7c/d2/a361b4831494531d5112e000d92762fc2926ed45ca7f9e9013f2e90c011c/dulwich-0.20.24.tar.gz"
    sha256 "6b61ac0a2a8b1b1e18914310f3f7a422396334208b426b9de570f1de31644cf1"
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
    url "https://files.pythonhosted.org/packages/be/c7/682519d7406e0933cd3c94867eb3b4e8f3090401b263d630dc1adf08a66a/localstack-client-1.22.tar.gz"
    sha256 "1517964f5d3746220abf2292b186050bdf28e1643072776a1810fb836033b3d9"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/30/cf/d9846d979de255ddc2a8068c6dd78c59486ef40e4a688395ac7836aabade/localstack-ext-0.12.13.31.tar.gz"
    sha256 "a3fe25daf9d955117f27c114ab74f9e0c5fdc793a6fa644b4b10b0e14d9ea8d5"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
    sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
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
