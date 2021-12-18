class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://github.com/localstack/localstack"
  url "https://files.pythonhosted.org/packages/a0/79/336f893c4e69d769a72a83228e6a3c15bcab70611c337deb6a0b64939298/localstack-0.13.1.2.tar.gz"
  sha256 "fdbd4e02ea809816a8828dfecbb6d2afe0ce6f06f5da27f1efe55f0b00c52599"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb6258873fba9aec7226ea00b17075ddebbf844949c07a2cc18204c3eeec88fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecf066db6b6c7ecb442b91b04f967d83ea1141794a97485c21e57e9e3e988830"
    sha256 cellar: :any_skip_relocation, monterey:       "db3280ab31096ba462b0c37ab90fa8a835f368922507d7bc733959e651ddbc51"
    sha256 cellar: :any_skip_relocation, big_sur:        "6455aae89c8bf8e016edd9237d8777af20ecd18dc274b9b8a96249e2b3094ea0"
    sha256 cellar: :any_skip_relocation, catalina:       "66fcd18cb054abef40f800d70dc7004b909278fb3d14f7e6f239d78993a28544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f89fe1d716f73079d0d968c7183968b507be3fc08777581494a02f3cfb7b4b65"
  end

  depends_on "docker" => :test
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  on_linux do
    depends_on "rust" => :build
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/7c/16/f1311747c6eb9a4f69b9a07e82e7836f4e8c925f9006f24f715a8f3ec0c6/boto3-1.20.24.tar.gz"
    sha256 "739705b28e6b2329ea3b481ba801d439c296aaf176f7850729147ba99bbf8a9a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2e/32/9103b5c8a8e2596f39e6db658f1e2f4193ecdacec7539854c09ed4612699/botocore-1.23.24.tar.gz"
    sha256 "43006b4f52d7bb655319d3da0f615cdbee7762853acc1ebcb1d49f962e6b4806"
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
    url "https://files.pythonhosted.org/packages/46/fa/8aa9993017d381cff0908ef72c0e339733709e167557fbfb73eec4c2c9ed/dnslib-0.9.16.tar.gz"
    sha256 "2d66b43d563d60c469117c8cb615843e7d05bf8fb2e6cb00a637281d26b7ec7d"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/13/27/5277de856f605f3429d752a39af3588e29d10181a3aa2e2ee471d817485a/dnspython-2.1.0.zip"
    sha256 "e4a87f0b573201a0f3727fa18a516b055fd1107e0e5477cded4a2de497df1dd4"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/fa/a2/e46d7c1b51394a09271a3b07c3a68deb3a669429beafd444d9553ed52868/docker-5.0.0.tar.gz"
    sha256 "3e8bc47534e0ca9331d72c32f2881bb13b93ded0bcdeab3c833fb7cf61c0a9a5"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/c7/f0/04e7aae32c5c45666fa94fa146ba3a6f78d44ed9fd11f3fc497bd6a3d13e/dulwich-0.20.26.tar.gz"
    sha256 "38aa50f859c8ea53071a049c3f1d5cc54f7dc60a4136a1ab631756a79f6582b5"
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
    url "https://files.pythonhosted.org/packages/2d/ca/19845cbd83383527a2ea85e940db448dd5c6c95876ade7c1ae142fb6d9a6/localstack-client-1.28.tar.gz"
    sha256 "fd4bfa81444134ac7bd115876c8b0e63d0c34b66e448866cad7d61a86f3abe9c"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/a9/ad/b3e607835af426b60199cedcc5c66f3d3bb29db33a9d491cceb07704e8ef/localstack-ext-0.13.0.27.tar.gz"
    sha256 "8ad731e316bbd126e5f5c01a3e2a3d766ee4fb32aeb0af390305a5e53f29ad37"
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
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
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
    url "https://files.pythonhosted.org/packages/b3/3b/5a90d0f197087896472757ebd9ac29d802ccc4f6953d99a535b1a8db2bf6/rich-10.16.1.tar.gz"
    sha256 "4949e73de321784ef6664ebbc854ac82b20ff60b2865097b93f3b9b41e30da27"
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
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
