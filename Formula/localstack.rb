class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://github.com/localstack/localstack"
  url "https://files.pythonhosted.org/packages/96/93/b3f7aeed606ef9d55155dff58f3baf347b5f5d2bab95ae7ee9e9ef7a21aa/localstack-0.14.0.3.tar.gz"
  sha256 "0111b67cdd84126967a3f5e5ec595be3702fd54cffe732f85faf41a1d378056c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f949c435922ee5af9af392bc7224c55b2afe4cc7aee07c6da18419102b1505f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "445a56a1b172048487d8608a26f0553c5d9b92b5f516457b63b0d858f4b0e4a1"
    sha256 cellar: :any_skip_relocation, monterey:       "e47405b96a2be74df26344913342c1cd8065ffe72e6672ecfaae8d6e44539d2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "436dad2366856b4452d317a36e767a0513ff635ec97e1c5b7c99362bf96af8b4"
    sha256 cellar: :any_skip_relocation, catalina:       "b5ffd702adb786249691fe12013ab3419287d1eec161b4112a45baa99a5627fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9c691449cc9299febcbd8abe10934b6a670a5cdc4a87a1290e37d8fdcf323e8"
  end

  depends_on "docker" => :test
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  on_linux do
    depends_on "rust" => :build
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/c2/b1/21097a7762ba045fa145719e73737c8e8e0b1bff03c3ab611614b748d141/boto3-1.21.4.tar.gz"
    sha256 "bbe4f4ddfc13469d306f0ca5fa77441ec37ad50dc270755e93260aeafb06d3d1"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/87/33/43f4b6ca1dc096888b9797dd95c3bcbd936497305b61835a6d123ff64793/botocore-1.24.4.tar.gz"
    sha256 "8e9ae6b718ca318b4aeeee45aa9fad5f52e882a2291d919cfa4b753928223abb"
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
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
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
    url "https://files.pythonhosted.org/packages/92/b0/f36f0c2ec1370b1d6d81f05b6490eca6c63e289cf08fa5fdcc242b565727/localstack-ext-0.14.0.10.tar.gz"
    sha256 "b7a3860b17403f8c7bdb8ade0f2a5092c8bf8618afe59d755ccfe040749a4c0d"
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
    url "https://files.pythonhosted.org/packages/51/da/eb358ed53257a864bf9deafba25bc3d6b8d41b0db46da4e7317500b1c9a5/pbr-5.8.1.tar.gz"
    sha256 "66bc5a34912f408bb3925bf21231cb6f59206267b7f63f3503ef865c1a292e25"
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
    url "https://files.pythonhosted.org/packages/72/de/b3a53cf1dfdbdc124e8110a60d6c6da8e39d4610c82491fc862383960552/rich-11.2.0.tar.gz"
    sha256 "1a6266a5738115017bb64a66c59c717e7aa047b3ae49a011ede4abdeffc6536e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/66/e2/cc19f36aade1ef40cba69555fcf713d942ec9e31ecff2415948bd885911d/s3transfer-0.5.1.tar.gz"
    sha256 "69d264d3e760e569b78aaa0f22c97e955891cd22e32b10c51f784eeda4d9d10a"
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
