class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://github.com/localstack/localstack"
  url "https://files.pythonhosted.org/packages/f0/d8/37bb020723c2822b23b4457565cf9033f6500d4e9e65566e8e5cd28fcca9/localstack-0.13.3.4.tar.gz"
  sha256 "ef08bdd10eca288438d04113b45319aa584d5c7d7b3c8a03010b73ed0ec48a4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c9af5f4f2d4a8d0fd0f2314009b6c972c675fc3e112e936080c5eba98ac0881"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b755fb094b4055de8563553c8a84c10564b1b490adc975d3ddbd57364b4f896c"
    sha256 cellar: :any_skip_relocation, monterey:       "842769f1bfc8659e0c682dceb0779ca8bfd89d1370fda6cb55d27e0b2a03553a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b000cfbc00c6db8d172c66fc7d42a4480d12fda04cfa354e0ec48820d68036fb"
    sha256 cellar: :any_skip_relocation, catalina:       "7bf37757eb3667bbef0d40b7027a23fdbc810ab72cd8e6517e6bc9bbbd1b606d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf6bb714c43f5459f92911a83e8c1fff5e5a95b1ee618f4eb5bab6a62aa11f80"
  end

  depends_on "docker" => :test
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  on_linux do
    depends_on "rust" => :build
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f6/b0/e42a79e8dc51ff9d9817c12d911893049cfddefbe3e2c062401306102fb9/boto3-1.20.46.tar.gz"
    sha256 "d7effba509d7298ef49316ba2da7a2ea115f2a7ff691f875f6354666663cf386"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/97/b9/f55bf7f44377c1093f16f789979b39d9bed51ad1f2069d17d1ca55d2d4c2/botocore-1.23.46.tar.gz"
    sha256 "38dd4564839f531725b667db360ba7df2125ceb3752b0ba12759c3e918015b95"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/ae/37/7fd45996b19200e0cb2027a0b6bef4636951c4ea111bfad36c71287247f6/cachetools-3.1.1.tar.gz"
    sha256 "8ea2d3ce97850f31e4a08b0e2b5e6c34997d7216a9d2c98e0f3978630d4da69a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "deepdiff" do
    url "https://files.pythonhosted.org/packages/44/46/94a28a8a12889f61ab5a63f68665123d1b671b6eaf861d3ad3ed65614bf1/deepdiff-5.7.0.tar.gz"
    sha256 "838766484e323dcd9dec6955926a893a83767dc3f3f94542773e6aa096efe5d4"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/e2/96/518a8ea959a734b70d2e95fef98bcbfdc7adad1c1e5f5dd9148c835205a5/dill-0.3.2.zip"
    sha256 "6e12da0d8e49c220e8d6e97ee8882002e624f1160289ce85ec2cc0a5246b3a2e"
  end

  resource "dnslib" do
    url "https://files.pythonhosted.org/packages/e1/96/5889c7fc3b55e727deae20d6a3157423f1355d3dac010c1f1c53dca017bd/dnslib-0.9.19.tar.gz"
    sha256 "a6e36ca96c289e2cb4ac6aa05c037cbef318401ba8ff04a8676892ca79749c77"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/84/f4/84eca79c279640671b8b7086ef1b97268c2b7ba17f7cfe0a19b466a6f95c/dnspython-2.2.0.tar.gz"
    sha256 "e79351e032d0b606b98d38a4b0e6e2275b31a5b85c873e587cc11b73aca026d6"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/fa/a2/e46d7c1b51394a09271a3b07c3a68deb3a669429beafd444d9553ed52868/docker-5.0.0.tar.gz"
    sha256 "3e8bc47534e0ca9331d72c32f2881bb13b93ded0bcdeab3c833fb7cf61c0a9a5"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/77/42/8a7669dbea5086ed2ee759d75414764a8256070d3c9adcf0e2067ebd9891/dulwich-0.20.32.tar.gz"
    sha256 "dc5498b072bdc12c1effef4b6202cd2a4542bb1c6dbb4ddcfc8c6d53e08b488c"
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
    url "https://files.pythonhosted.org/packages/4f/b4/92dbff5938fd135909bb1cf0b4c27c5a1b3221784dc6087c1773942fcbcd/localstack-client-1.31.tar.gz"
    sha256 "7030dae0d778feef0a790800ba3d50af81d49e410e97df7ddd6ff442e05825a7"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/29/f4/852f81d381ac49a995a93c9cc4a95c5225383ecbe0b8c514985a3812b9d1/localstack-ext-0.13.3.11.tar.gz"
    sha256 "d9f76c929708e907cff602a787ce2dee1bc16bddf85975846c714fe403490a58"
  end

  resource "localstack-plugin-loader" do
    url "https://files.pythonhosted.org/packages/2e/82/7e78c8056df07bf05196ee40b4244399f7a66ee5c1fe7ac1c837bf30755b/localstack-plugin-loader-1.1.1.tar.gz"
    sha256 "eb829c47332caf2ff1062a2038077e0a5e93c30bb2c61cf2651b07ccadd77448"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/f5/ab/8252360bfe965bba31ec05112b3067bd129ce4800d89e0b85613bc6044f6/ordered-set-4.0.2.tar.gz"
    sha256 "ba93b2df055bca202116ec44b9bead3df33ea63a7d5827ff8e16738b97f33a95"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/f5/0c/3fa7b1f9006e4d454a49b48eac995167cf8617e19375c6963a6b048af0d0/pbr-5.8.0.tar.gz"
    sha256 "672d8ebee84921862110f23fcec2acea191ef58543d34dfe9ef3d9f13c31cddf"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/47/b6/ea8a7728f096a597f0032564e8013b705aa992a0990becd773dcc4d7b4a7/psutil-5.9.0.tar.gz"
    sha256 "869842dbd66bb80c3217158e629d6fceaecc3a3166d3d1faee515b05dd26ca25"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/49/62/4f25667e10561303a34cb89e3187c35985c0889b99f6f1468aaf17fbb03e/python-dotenv-0.19.2.tar.gz"
    sha256 "a5de49a31e953b45ff2d2fd434bbc2670e8db5273606c1e737cc6b93eff3655f"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/81/d2/64751634e1af18e61454e9946c8c792ab3866c2b309615844fc435036715/rich-11.1.0.tar.gz"
    sha256 "43e03d8eec12e21beaecc22c828a41c4247356414a12d5879834863d4ad53816"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/67/73/cd693fde78c3b2397d49ad2c6cdb082eb0b6a606188876d61f53bae16293/stevedore-3.5.0.tar.gz"
    sha256 "f40253887d8712eaa2bb0ea3830374416736dc8ec0e22f5a65092c1174c44335"
  end

  resource "tailer" do
    url "https://files.pythonhosted.org/packages/dd/05/01de24d6393d6da0c27857c76b0f9ae97b42cd6102bbdf76cce95e031295/tailer-0.4.1.tar.gz"
    sha256 "78d60f23a1b8a2d32f400b3c8c06b01142ac7841b75d8a1efcb33515877ba531"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/b6/fa/72e77d094563208174abbbaa73c32f28c43a31193b843bddf233c7c87644/websocket-client-1.2.3.tar.gz"
    sha256 "1315816c0acc508997eb3ae03b9d3ff619c9d12d544c9a9b553704b1cc4f6af5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["DOCKER_HOST"] = "unix://" + (testpath/"invalid.sock")

    assert_match version.to_s, shell_output("#{bin}/localstack --version")

    output = shell_output("#{bin}/localstack start --docker", 1)

    assert_match "starting LocalStack in Docker mode", output
  end
end
