class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://github.com/localstack/localstack"
  url "https://files.pythonhosted.org/packages/50/8f/7868aa93300fc3872321a938ec2dd2560a0f1f11c4fabd3ae464101cf0ef/localstack-0.12.20.tar.gz"
  sha256 "92eabd00ce5a3073253b30b4450faead93b6c24ec3530df06142683c7f82b890"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "421d14ca8bde8fe64a34c313dd111e731da7ea1c51dd109d2af41777c332f7dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25e43b1959901309d7d2cb3250dbcac6d441833a15810773d9652cd1b1426147"
    sha256 cellar: :any_skip_relocation, monterey:       "0752c60ad905d3273dc176ba06a81563bdb25521f7a7df2738d21e703622e248"
    sha256 cellar: :any_skip_relocation, big_sur:        "535c8f5c65b763502ce61e3ccfc201a2b59f778cab320ce37c13350ea2ecdc1c"
    sha256 cellar: :any_skip_relocation, catalina:       "45ff4439805fafba3c3239839ff2bea94d832d3f424fc93aa7b20a70729d2613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e27b4375500ca66936f039a2d92fcfe6eb17a8be220b6ffaa22e34259b2fb1e7"
  end

  depends_on "docker" => :test
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  on_linux do
    depends_on "rust" => :build
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/6d/27/5a5e2c3048d83dcbbd89167810e59d67035bdcb5e2aa2453b8f171e12c27/boto3-1.20.0.tar.gz"
    sha256 "17b942d9513f396b2e90f71131b48cdc49279c9714189bbf84a232d189a793dd"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/28/e4/202d80d8f891949537ca83398ff5586068c6ab515bdaac85936169578309/botocore-1.23.1.tar.gz"
    sha256 "3daa7148017685ee8120c12b024ad2b6eadc1abc775627d4f4dd8182aaca5d0f"
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
    url "https://files.pythonhosted.org/packages/3b/87/cb128ce060810739f94305e16b5ac6bb25f200b2615489d3f7b15b8db5db/localstack-client-1.26.tar.gz"
    sha256 "c5e7577fd5836be83f3548ca90e739a4599174c50823f6c1ef1c7961c709f65e"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/60/a1/bb0e0a64c77b9334d1c7a7f1d35ad0918e518b0188b5775edaaa8377da16/localstack-ext-0.12.20.tar.gz"
    sha256 "0b8e58624ee64e57ce82636baec93a472322820ff082ce4d4f10b567c472a56d"
  end

  resource "localstack-plugin-loader" do
    url "https://files.pythonhosted.org/packages/2e/82/7e78c8056df07bf05196ee40b4244399f7a66ee5c1fe7ac1c837bf30755b/localstack-plugin-loader-1.1.1.tar.gz"
    sha256 "eb829c47332caf2ff1062a2038077e0a5e93c30bb2c61cf2651b07ccadd77448"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/69/7e/e420b9b6b06f9597827571e871f9492512701497971a4cf3f4638c03bc7a/pbr-5.7.0.tar.gz"
    sha256 "4651ca1445e80f2781827305de3d76b3ce53195f2227762684eb08f17bc473b7"
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

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/dc/b4/ad6cac44c9978787cc73d8dd36373665ad3b8613be9120a893e87b99e134/rich-10.13.0.tar.gz"
    sha256 "d80fc76f34d819c481a48f73ec9ac396bed3bd6a16ecd57f9e0654cd89a8fb56"
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

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/4e/8f/b5c45af5a1def38b07c09a616be932ad49c35ebdc5e3cbf93966d7ed9750/websocket-client-1.2.1.tar.gz"
    sha256 "8dfb715d8a992f5712fff8c843adae94e22b22a99b2c5e6b0ec4a1a981cc4e0d"
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
