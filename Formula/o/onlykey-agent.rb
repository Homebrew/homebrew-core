class OnlykeyAgent < Formula
  include Language::Python::Virtualenv

  desc "Middleware that lets you use OnlyKey as a hardware SSH/GPG device"
  homepage "https://docs.crp.to/onlykey-agent.html"
  url "https://files.pythonhosted.org/packages/68/80/e89b6c3680bedb1e14e99f0539ac805bddc7d8dd87c58805c64484966b7c/onlykey-agent-1.1.15.tar.gz"
  sha256 "49b19bec28dc0fb7053ef01266d8a9e7a078bb146214a641bdbb1feac6fc7ddb"
  license "LGPL-3.0-only"
  revision 4

  bottle do
    rebuild 5
    sha256 cellar: :any,                 arm64_sequoia: "b815e4288102059716896bc6bfb08cd00ef2f126f2c3769da0bf7672d80c873e"
    sha256 cellar: :any,                 arm64_sonoma:  "1514e42110537c744a075238c45fca5d832f7057f517787d35b1dc864a418577"
    sha256 cellar: :any,                 arm64_ventura: "dc66fe96ea14c51b5e890e0aebc6ab7d14cd6ed113545a12d907f3a38c642958"
    sha256 cellar: :any,                 sonoma:        "d2c8c844451378fbfcb691acab825950ea5f74ec2e8324d2a3c9ebcb3d201d2e"
    sha256 cellar: :any,                 ventura:       "20b57aec00914cb13cf6b455be4f34e4b415e9ee69c983640cf0740b44f25ef0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdeb03a92ecefbea76749a8986ee5524f357edb163b36d4cdf08602de21002a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "936e4decb9ea4681973c1572b7ee8e7e204c920abd35d2e1bcff1b6935a1aa4e"
  end

  depends_on "pkgconf" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "gnupg"
  depends_on "hidapi"
  depends_on "libsodium" # for pynacl
  depends_on "libusb" # for pyusb
  depends_on "python@3.13"

  resource "aenum" do
    url "https://files.pythonhosted.org/packages/d0/f8/33e75863394f42e429bb553e05fda7c59763f0fd6848de847a25b3fbccf6/aenum-3.1.15.tar.gz"
    sha256 "8cbd76cd18c4f870ff39b24284d3ea028fbe8731a58df3aa581e434c575b9559"
  end

  resource "backports-shutil-which" do
    url "https://files.pythonhosted.org/packages/a0/22/51b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5/backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "bech32" do
    url "https://files.pythonhosted.org/packages/ab/fe/b67ac9b123e25a3c1b8fc3f3c92648804516ab44215adb165284e024c43f/bech32-1.2.0.tar.gz"
    sha256 "7d6db8214603bd7871fcfa6c0826ef68b85b0abd90fa21c285a9c5e21d2bd899"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/5a/25/886e197c97a4b8e254173002cdc141441e878ff29aaa7d9ba560cd6e4866/cython-3.0.12.tar.gz"
    sha256 "b988bb297ce76c671e28c97d017b95411010f7c77fa6623dd0bb47eed1aee1bc"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/c0/1f/924e3caae75f471eae4b26bd13b698f6af2c44279f67af317439c2f4c46a/ecdsa-0.19.1.tar.gz"
    sha256 "478cba7b62555866fcb3bb3fe985e06decbdb68ef55713c4e5ab98c57d508e61"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/74/6e/58e1bb40a284291ab483d00831c5b91fe14d498a3ae7c658f3c588658e4b/fido2-0.9.3.tar.gz"
    sha256 "b45e89a6109cfcb7f1bb513776aa2d6408e95c4822f83a253918b944083466ec"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/47/72/21ccaaca6ffb06f544afd16191425025d831c2a6d318635e9c8854070f2d/hidapi-0.14.0.post4.tar.gz"
    sha256 "48fce253e526d17b663fbf9989c71c7ef7653ced5f4be65f1437c313fb3dbdf6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "intelhex" do
    url "https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01/intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "lib-agent" do
    url "https://files.pythonhosted.org/packages/96/65/453f7b077b55610ad46a7018027af44d39e3affa56950d67dc1fdbfdc622/lib-agent-1.0.6.tar.gz"
    sha256 "22b262cc81c320f1e8e2d55db946adeeedf5cc7a3736df2070c3b2514aa436ed"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/ff/77/e6232ed59fbd7b90208bb8d4f89ed5aabcf30a524bc2fb8f0dafbe8e7df9/mnemonic-0.21.tar.gz"
    sha256 "1fe496356820984f45559b1540c80ff10de448368929b9c60a2b55744cc88acf"
  end

  resource "onlykey" do
    url "https://files.pythonhosted.org/packages/95/27/5bf7048f6d9de97610b6252b392a6d2d7e929dcd82809b973aebf1727114/onlykey-1.2.10.tar.gz"
    sha256 "666427c99c7d625208c4c31d674536cdbf9000d7dcc2bb46ee24752e98339814"
  end

  resource "onlykey-solo-python" do
    url "https://files.pythonhosted.org/packages/f5/aa/da868b3a695ed2de3ffd71455a8269e031fd478957e888028480f7331c6b/onlykey-solo-python-0.0.32.tar.gz"
    sha256 "f3c0ee8605f8142c3320acf0e11a9680cb6345d7f986e5652841c00049a29ee4"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/44/e6/099310419df5ada522ff34ffc2f1a48a11b37fc6a76f51a6854c182dbd3e/pycryptodome-3.22.0.tar.gz"
    sha256 "fd7ab568b3ad7b77c908d7c3f7e167ec5a8f035c64ff74f10d47a4edd043d723"
  end

  resource "pymsgbox" do
    url "https://files.pythonhosted.org/packages/7d/ff/4c6f31a4f08979f12a663f2aeb6c8b765d3bd592e66eaaac445f547bb875/PyMsgBox-1.0.9.tar.gz"
    sha256 "2194227de8bff7a3d6da541848705a155dcbb2a06ee120d9f280a1d7f51263ff"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/3d/37/4f10e37bdabc058a32989da2daf29e57dc59dbc5395497f3d36d5f5e2694/python_daemon-3.1.2.tar.gz"
    sha256 "f7b04335adc473de877f5117e26d5f1142f4c9f7cd765408f0877757be5afbf4"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/00/6b/ce3727395e52b7b76dfcf0c665e37d223b680b9becc60710d4bc08b7b7cb/pyusb-1.3.1.tar.gz"
    sha256 "3af070b607467c1c164f49d5b0caabe8ac78dbed9298d703a8dbf9df4052d17e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/f7/89/19151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3e/Unidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # the device mut not be plugged in to get the expected message
    # since CI is the foremost user of `brew test` we assume that there is no device
    output = shell_output("#{bin}/onlykey-agent test@example.com 2>&1", 1)
    assert_match("try unplugging and replugging your device", output)
  end
end
