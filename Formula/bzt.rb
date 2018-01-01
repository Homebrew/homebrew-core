class Bzt < Formula
  include Language::Python::Virtualenv
  desc "BlazeMeter Taurus"
  homepage "https://gettaurus.org/"
  url "https://files.pythonhosted.org/packages/source/b/bzt/bzt-1.10.3.tar.gz"
  sha256 "1a8ad80fc9a4ed54aa1b099bef6590adc3cfd806322d3a11a0d9decdf9477acf"
  head "https://github.com/greyfenrir/taurus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e3810525a9826146176d241873245f164e9c282084e85af59bf16ea507d3ac2" => :high_sierra
    sha256 "3b550bd4ed999c58e2524141f24b606f325ee914e9b5f93fd90c2c7f3143fbb0" => :sierra
    sha256 "bcb9efe7a50156ccfe5d92f7d0d2fa9d3fefc22863b18d63f38dfeb2c8f80107" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "apiritif" do
    url "https://files.pythonhosted.org/packages/df/97/a298d2c08970171c7683b34b30e0af4a0f710ad7a1a4bb9dec7caa41b3b0/apiritif-0.4.tar.gz"
    sha256 "179e40110f55dd015d11ac6578e9a57786512968e3b4b6d5a9df6ebe6a5dbbff"
  end

  resource "astunparse" do
    url "https://files.pythonhosted.org/packages/1a/b7/3ba7ce33cbc8847e20ed1a4fbec2303a71b2512dec0194824e8dcaadc8de/astunparse-1.5.0.tar.gz"
    sha256 "55df3c2a659d6cb6a9a9041c750a8232a9925523405a8dfeb891b92d45a589cd"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/23/3f/8be01c50ed24a4bd6b8da799839066ce0288f66f5e11f0367323467f0cbc/certifi-2017.11.5.tar.gz"
    sha256 "5ec74291ca1136b40f0379e1128ff80e866597e4e2c1e755739a913bbc3613c0"
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
    url "https://files.pythonhosted.org/packages/64/cf/9d2d7dba6cc4a877155d224441d3af2b6cab3d6c9c3c03811894395268fc/colorlog-3.1.0.tar.gz"
    sha256 "f7c0efd9d960b43929027aa2b5a6c80d8ebec3e8d87cdec8b92696bf57428284"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/77/ff/9c865275cd19290feba56344eba570e719efb7ca5b34d67ed12b22ebbb0d/cssselect-1.0.1.tar.gz"
    sha256 "73db1c054b9348409e2862fc6c0dde5c4e4fbe4da64c5c5a9e05fbea45744077"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/bb/e0/f6e41e9091e130bf16d4437dabbac3993908e4d6485ecbc985ef1352db94/decorator-4.1.2.tar.gz"
    sha256 "7cb64d38cb8002971710c8899fbdfb859a23a364b7c99dab19d1f719c2ba16b5"
  end

  resource "EasyProcess" do
    url "https://files.pythonhosted.org/packages/0d/f1/d2de7591e7dfc164d286fa16f051e6c0cf3141825586c3b04ae7cda7ac0f/EasyProcess-0.2.3.tar.gz"
    sha256 "94e241cadc9a46f55b5c06000df85618849602e7e1865b8de87576b90a22e61f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
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

  resource "ply" do
    url "https://files.pythonhosted.org/packages/ce/3d/1f9ca69192025046f02a02ffc61bfbac2731aab06325a218370fd93e18df/ply-3.10.tar.gz"
    sha256 "96e94af7dd7031d8d6dd6e2a8e0de593b511c211a86e28a9c9621c275ac8bacb"
  end

  resource "progressbar33" do
    url "https://files.pythonhosted.org/packages/71/fc/7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6b/progressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/fe/17/0f0bf5792b2dfe6003efc5175c76225f7d3426f88e2bf8d360cfab870cd8/psutil-5.4.1.tar.gz"
    sha256 "42e2de159e3c987435cb3b47d6f37035db190a1499f3af714ba7af5c379b6ba2"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/90/e3/e075127d39d35f09a500ebb4a90afd10f9ef0a1d28a6d09abeec0e444fdd/py-1.5.2.tar.gz"
    sha256 "ca18943e28235417756316bfada6cd96b23ce60dd532642690dcfdaba988a76d"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/1f/f8/8cd74c16952163ce0db0bd95fdd8810cbf093c08be00e6e665ebf0dc3138/pytest-3.2.5.tar.gz"
    sha256 "6d5bd4f7113b444c55a3bbb5c738a3dd80d43563d063fc42dcb0aaefbdd78b81"
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
    url "https://files.pythonhosted.org/packages/bc/37/aea63b9651d5f27c9349895fc72862e2e14ed264e8f5d3eedc602c41254a/selenium-3.7.0.tar.gz"
    sha256 "70be7e090042303564ff48bedef0b34477d463056a2d282c1dbd4c4c180ef8e1"
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
    url "https://files.pythonhosted.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
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
