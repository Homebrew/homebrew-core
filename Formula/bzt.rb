class Bzt < Formula
  include Language::Python::Virtualenv
  desc "BlazeMeter Taurus"
  homepage "https://gettaurus.org/"
  url "https://files.pythonhosted.org/packages/source/b/bzt/bzt-1.10.5.tar.gz"
  sha256 "636eb56f851f8c9bab0632a4019cca2ac775b5bb08de5d51557c3806f996f768"
  head "https://github.com/greyfenrir/taurus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf00117a6cfade7f739253d68e7397e9e7f243a716b91946c3a608e7addb300e" => :high_sierra
    sha256 "5dbd18545da240b445cb79f29c78c37ee5bec77c5072725c620279ead7582424" => :sierra
    sha256 "4ce27b964cbfc81e2e681751484c8d8e3bebe5acdbfa965c23c8a77c8b731bd2" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "apiritif" do
    url "https://files.pythonhosted.org/packages/72/ef/302a89b0106abc43dcd413a67a37d77a28c0690c5037ff38f33a126a192d/apiritif-0.5.tar.gz"
    sha256 "9428df3cb32ec0d0424c14c7b1c8470892cec2edb3a8adb4424fc845c4acc1fe"
  end

  resource "astunparse" do
    url "https://files.pythonhosted.org/packages/1a/b7/3ba7ce33cbc8847e20ed1a4fbec2303a71b2512dec0194824e8dcaadc8de/astunparse-1.5.0.tar.gz"
    sha256 "55df3c2a659d6cb6a9a9041c750a8232a9925523405a8dfeb891b92d45a589cd"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/8b/0b/a06cfcb69d0cb004fde8bc6f0fd192d96d565d1b8aa2829f0f20adb796e5/attrs-17.4.0.tar.gz"
    sha256 "1c7960ccfd6a005cd9f7ba884e6316b5e430a3f1a6c37c5f87d8b43f83b54ec9"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/15/d4/2f888fc463d516ff7bf2379a4e9a552fef7f22a94147655d9b1097108248/certifi-2018.1.18.tar.gz"
    sha256 "edbc3f203427eef571f79a7692bb160a2b0f7ccaa31953e99bd17e307cf63f7d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/e6/76/257b53926889e2835355d74fec73d82662100135293e17d382e2b74d1669/colorama-0.3.9.tar.gz"
    sha256 "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/b8/a3/d181e256fba34d07ac3a052269cc0a43a61cfec14674bceaa1cca1f5fdb0/colorlog-3.1.2.tar.gz"
    sha256 "7f94b6a88e789e68025b84f2581c17a52c8fb3c07e07a23e7e22bf774dd34144"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/52/ea/f31e1d2e9eb130fda2a631e22eac369dc644e8807345fbed5113f2d6f92b/cssselect-1.0.3.tar.gz"
    sha256 "066d8bc5229af09617e24b3ca4d52f1f9092d9e061931f4184cd572885c23204"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/70/f1/cb9373195639db13063f55eb06116310ad691e1fd125e6af057734dc44ea/decorator-4.2.1.tar.gz"
    sha256 "7d46dd9f3ea1cf5f06ee0e4e1277ae618cf48dfb10ada7c8427cd46c42702a0e"
  end

  resource "EasyProcess" do
    url "https://files.pythonhosted.org/packages/0d/f1/d2de7591e7dfc164d286fa16f051e6c0cf3141825586c3b04ae7cda7ac0f/EasyProcess-0.2.3.tar.gz"
    sha256 "94e241cadc9a46f55b5c06000df85618849602e7e1865b8de87576b90a22e61f"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/f0/ba/860a4a3e283456d6b7e2ab39ce5cf11a3490ee1a363652ac50abf9f0f5df/ipaddress-1.0.19.tar.gz"
    sha256 "200d8686011d470b5e4de207d803445deee427455cd0cb7c982b68cf82524f81"
  end

  resource "jsonpath-rw" do
    url "https://files.pythonhosted.org/packages/71/7c/45001b1f19af8c4478489fbae4fc657b21c4c669d7a5a036a86882581d85/jsonpath-rw-1.4.0.tar.gz"
    sha256 "05c471281c45ae113f6103d1268ec7a4831a2e96aa80de45edc89b11fac4fbec"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e1/4c/d83979fbc66a2154850f472e69405572d89d2e6a6daee30d18e83e39ef3a/lxml-4.1.1.tar.gz"
    sha256 "940caef1ec7c78e0c34b0f6b94fe42d0f2022915ffc78643d28538a5cfd0f40e"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/11/bf/cbeb8cdfaffa9f2ea154a30ae31a9d04a1209312e2919138b4171a1f8199/pluggy-0.6.0.tar.gz"
    sha256 "7f8ae7f5bdf75671a718d2daf0a64b7885f74510bcd98b1a0bb420eb9a9d0cff"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/ce/3d/1f9ca69192025046f02a02ffc61bfbac2731aab06325a218370fd93e18df/ply-3.10.tar.gz"
    sha256 "96e94af7dd7031d8d6dd6e2a8e0de593b511c211a86e28a9c9621c275ac8bacb"
  end

  resource "progressbar33" do
    url "https://files.pythonhosted.org/packages/71/fc/7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6b/progressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e2/e1/600326635f97fee89bf8426fef14c5c29f4849c79f68fd79f433d8c1bd96/psutil-5.4.3.tar.gz"
    sha256 "e2467e9312c2fa191687b89ff4bc2ad8843be4af6fb4dc95a7cc5f7d7a327b18"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/90/e3/e075127d39d35f09a500ebb4a90afd10f9ef0a1d28a6d09abeec0e444fdd/py-1.5.2.tar.gz"
    sha256 "ca18943e28235417756316bfada6cd96b23ce60dd532642690dcfdaba988a76d"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/a8/84/25b93a15997be680fc8ce1a7b9315b03650ced546908e5008c0912b1c2e1/pytest-3.4.0.tar.gz"
    sha256 "6074ea3b9c999bd6d0df5fa9d12dd95ccd23550df2a582f5f5b848331d2e82ca"
  end

  resource "PyVirtualDisplay" do
    url "https://files.pythonhosted.org/packages/39/37/f285403a09cc261c56b6574baace1bdcf4b8c7428c8a7239cbba137bc0eb/PyVirtualDisplay-0.2.1.tar.gz"
    sha256 "012883851a992f9c53f0dc6a512765a95cf241bdb734af79e6bdfef95c6e9982"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/b4/54/ba7059b254a72fc30f1d8b838eb951003ee6e5ba716bb9b0ce0e4c58e308/selenium-3.9.0.tar.gz"
    sha256 "a34a833d89bcfb463bfba5e5515a9276bb94221787b409f0ad28d2f91903e31d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/c7/90/415728875c230fafd13d118512bde3184d810d7bf798a631abc05fac09d0/urwid-2.0.1.tar.gz"
    sha256 "644d3e3900867161a2fc9287a9762753d66bd194754679adb26aede559bcccbc"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fa/b4/f9886517624a4dcb81a1d766f68034344b7565db69f13d52697222daeb72/wheel-0.30.0.tar.gz"
    sha256 "9515fe0a94e823fd90b08d22de45d7bde57c90edce705b22f5e1ecf7e1b653c8"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    virtualenv_install_with_resources
  end

  test do
    cmd = "#{bin}/bzt -o execution.executor=nose -o execution.iterations=1 -o execution.scenario.requests.0=https://gettaurus.org/"
    assert_match "INFO: Samples count: 1, 0.00% failures", shell_output(cmd)
  end
end
