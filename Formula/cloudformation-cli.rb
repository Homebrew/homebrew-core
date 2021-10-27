class CloudformationCli < Formula
  include Language::Python::Virtualenv

  desc "CloudFormation Provider Development Toolkit"
  homepage "https://github.com/aws-cloudformation/cloudformation-cli/"
  url "https://files.pythonhosted.org/packages/9a/c9/ea12429f8076e919f6cf75acd0613bd39cc490d5ff2943405ec79bf93f49/cloudformation-cli-0.2.20.tar.gz"
  sha256 "5150bd1ab79a4574ac32b8d7651ea9c38593a82ca08e44dcfee6f89f3add9d00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b707eba70ec6b4037554801d5d5c351e5d3773ae47b005d98634da587788637f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a690ab8c754f8ea00bfc6674c75a5674efc8ee78a4ab380012e87fadae28683b"
    sha256 cellar: :any_skip_relocation, big_sur:        "77c997cacf1cc396c9499ebd8ac005c98e63cf33ea31786747f41ed2c751d3d2"
    sha256 cellar: :any_skip_relocation, catalina:       "b38fcbbf33001f8c8967552622dca8eb6ca6f2dd86e8696e978348a6a47c1188"
    sha256 cellar: :any_skip_relocation, mojave:         "eb5e650d492cd8b393441ac435aef022a853a34741035b97b5077fbd70dfa5f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de2b06e933b343cce91dc3da1682b509408c7f8c69bf46b42e87342067c7ffeb"
  end

  depends_on "go" => :test
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "expect" => :test

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/06/16/20e660646b3b81d721973d409a64898c0c569dcd14221041098e7d2680bf/aws-sam-translator-1.39.0.tar.gz"
    sha256 "8973af434ef649861b03a104581b64c219fcf255adb7510e71a6e96914be3208"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/27/bc/a80d4cd852b9a8b4d4106ddf10266a99c29bc6b55663b43567cb97baced1/boto3-1.18.65.tar.gz"
    sha256 "baedf0637dd0e47cff60eb5591133f9c10aeb49581e2ad5a99794996a2dfbe09"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/23/4e/10672258ebb465d29c5143affa5e98afef10557bcbf931ffac799af4a50c/botocore-1.21.65.tar.gz"
    sha256 "6437d6a3999a189e7d45b3fcd8f794a46670fb255ae670c946d3f224caa8b46a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "cfn-lint" do
    url "https://files.pythonhosted.org/packages/90/93/994a49b78390be5a982fa5dc0ee78831dde5125034b7509cd67864737851/cfn-lint-0.54.2.tar.gz"
    sha256 "82a2cc7d6fa3bbdc303bf1eb87f92ba6b3c552d8aef31918b47b69648ce262d3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "cloudformation-cli-go-plugin" do
    url "https://files.pythonhosted.org/packages/8f/00/909410b531a330f3f8a784862dd0daf12541a99a969555e2b3c7af892ec7/cloudformation-cli-go-plugin-2.0.4.tar.gz"
    sha256 "2b6bc4eaa89b7c055a91b86ec957ef765b0c8a43f5af3c4fa916e2d4d3fd03d6"
  end

  resource "cloudformation-cli-java-plugin" do
    url "https://files.pythonhosted.org/packages/12/bf/0affe98e84e94e66ee0a479df2eec5376b71e3de396a0c78ffdc4fb96262/cloudformation-cli-java-plugin-2.0.7.tar.gz"
    sha256 "71060cf2de8cedad9753be7106e49c9d8913e9db8accbb6dca751828283c4511"
  end

  resource "cloudformation-cli-python-plugin" do
    url "https://files.pythonhosted.org/packages/57/cd/f438e70a4fdf01082f248880bda7b517e28fe9031f0013ebb964e5bdaab9/cloudformation-cli-python-plugin-2.1.4.tar.gz"
    sha256 "315740a371b8122a185cca99964be06a8b2d52200bd45b481245cb8a996a96a6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/ab/d2/45ea0ee13c6cffac96c32ac36db0299932447a736660537ec31ec3a6d877/docker-5.0.3.tar.gz"
    sha256 "d916a26b62970e7c2f554110ed6af04c7ccff8e9f81ad17d0d40c75637e227fb"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/ab/4b/71b3416b7aa03ecf1afa1f5639cb57ce0bbfce5fd6881c507b8e6955d618/hypothesis-6.23.3.tar.gz"
    sha256 "cf73011c43b51daa09ab5656df3a5db087097858c6984681c883bac61f2c2b55"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/23/a2/97899f6bd0e873fed3a7e67ae8d3a08b21799430fb4da15cfedf10d6e2c2/iniconfig-1.1.1.tar.gz"
    sha256 "bc3af051d7d14b2ee5ef9969666def0cd1a000e121eaea580d4a313df4b37f32"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6b/35/400557d3df63269a4c010cbd4865910b3c1718fbfe8d83210b216cd3efcf/jsonpointer-2.1.tar.gz"
    sha256 "5a34b698db1eb79ceac454159d3f7c12a451a91f6334a4f638454327b7a89962"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  # only doing this because junit-xml source is not available in PyPI for v1.9
  resource "junit-xml" do
    url "https://github.com/kyrus/python-junit-xml.git",
        revision: "4bd08a272f059998cedf9b7779f944d49eba13a6"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "nested-lookup" do
    url "https://files.pythonhosted.org/packages/1e/91/a387bb18e8cb56461e317f1a0a73c310d2e70e748c288bc10dd51fa0b996/nested-lookup-0.2.22.tar.gz"
    sha256 "e39adacd11e879dd6383b0a832cde97edce25d2a29cbc03a9c80fefa3a131e8b"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/97/ae/7497bc5e1c84af95e585e3f98585c9f06c627fac6340984c4243053e8f44/networkx-2.6.3.tar.gz"
    sha256 "c0946ed31d71f1b732b5aaa6da5a0388a345019af232ce2f49c766e2d6795c51"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/f5/ab/8252360bfe965bba31ec05112b3067bd129ce4800d89e0b85613bc6044f6/ordered-set-4.0.2.tar.gz"
    sha256 "ba93b2df055bca202116ec44b9bead3df33ea63a7d5827ff8e16738b97f33a95"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/0d/8c/50e9f3999419bb7d9639c37e83fa9cdcf0f601a9d407162d6c37ad60be71/py-1.10.0.tar.gz"
    sha256 "21b81bda15b66ef5e1a777a21c4dcd9c20ad3efd0b3f817e7a809035269e1bd3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/4b/24/7d1f2d2537de114bdf1e6875115113ca80091520948d370c964b88070af2/pytest-6.2.5.tar.gz"
    sha256 "131b36680866a76e6781d13f101efb86cf674ebb9762eb70d3082b6f29889e89"
  end

  resource "pytest-localserver" do
    url "https://files.pythonhosted.org/packages/6c/b3/db8f8700718fbefaa2e8b2ef690fec147e560ce92e2300cdb3ff462d313c/pytest-localserver-0.5.0.tar.gz"
    sha256 "3a5427909d1dfda10772c1bae4b9803679c0a8f04adb66c338ac607773bfefc2"
  end

  resource "pytest-random-order" do
    url "https://files.pythonhosted.org/packages/f4/70/e9f80dcbddfc131704d381fd3dc7822a1652765a1b88326a8d84bdc44738/pytest-random-order-1.0.4.tar.gz"
    sha256 "6b2159342a4c8c10855bc4fc6d65ee890fc614cb2b4ff688979b008a82a0ff52"
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
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "types-dataclasses" do
    url "https://files.pythonhosted.org/packages/aa/f1/ece799093b042b899aa6921081e65e4404894a44d27bf18490ee1065bee7/types-dataclasses-0.6.1.tar.gz"
    sha256 "6568532fed11f854e4db2eb48063385b323b93ecadd09f10a215d56246c306d7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/4e/8f/b5c45af5a1def38b07c09a616be932ad49c35ebdc5e3cbf93966d7ed9750/websocket-client-1.2.1.tar.gz"
    sha256 "8dfb715d8a992f5712fff8c843adae94e22b22a99b2c5e6b0ec4a1a981cc4e0d"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/83/3c/ecdb36f49ab06defb0d5a466cfeb4ae90a55d02cfef379f781da2801a45d/Werkzeug-2.0.2.tar.gz"
    sha256 "aa2bb6fc8dee8d6c504c0ac1e7f5f7dc5810a9903e793b6f715a9f015bdadb9a"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/cfn"
  end

  def caveats
    <<~EOS
      cloudformation java, go, python plugins are installed, but the Go and Java are not bundled with the installation.
    EOS
  end

  test do
    (testpath/"test.exp").write <<~EOS
      #!/usr/bin/env expect -f
      set timeout -1

      spawn #{bin}/cfn init

      expect -exact "Do you want to develop a new resource(r) or a module(m)?."
      send -- "r\r"

      expect -exact "What's the name of your resource type?"
      send -- "brew::formula::test\r"

      expect -exact "Select a language for code generation:"
      send -- "1\r"

      expect -exact "Enter the GO Import path"
      send -- "example\r"

      expect -exact "Initialized a new project in"
      expect eof
    EOS

    system "expect", "-f", "test.exp"

    rpdk_config = JSON.parse(File.read(testpath/".rpdk-config"))
    assert_equal "brew::formula::test", rpdk_config["typeName"]
    assert_equal "go", rpdk_config["language"]
    assert_predicate testpath/"rpdk.log", :exist?
  end
end
