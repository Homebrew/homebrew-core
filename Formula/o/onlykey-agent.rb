class OnlykeyAgent < Formula
  include Language::Python::Virtualenv

  desc "Middleware that lets you use OnlyKey as a hardware SSH/GPG device"
  homepage "https://docs.crp.to/onlykey-agent.html"
  url "https://files.pythonhosted.org/packages/68/80/e89b6c3680bedb1e14e99f0539ac805bddc7d8dd87c58805c64484966b7c/onlykey-agent-1.1.15.tar.gz"
  sha256 "49b19bec28dc0fb7053ef01266d8a9e7a078bb146214a641bdbb1feac6fc7ddb"
  license "LGPL-3.0-only"
  revision 7

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e7906f79878de2dc56273033eeb185463cfc07d2ead02e276d69c7bd66389298"
    sha256 cellar: :any,                 arm64_sequoia: "5695610e109d3b8adc292bbe6f4a22c6f84c7de6311e0012701db0dd0577f47a"
    sha256 cellar: :any,                 arm64_sonoma:  "7d9cb531924bac278de18fc7d531196b3c835c279a95591abbd8627a74d9428d"
    sha256 cellar: :any,                 sonoma:        "be5d5d76beb20617b55959cb8178064456c77737facb9e40090f008e4c5fdb86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "116bd86252c4cebd7963969bf68cd1d9b5aea1c3976e819a8a2690357fa70a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2c0d4631cfaa5459cfc36d19d63fee1faf9f1e8ab6d164e16e1a5f18a8521e2"
  end

  depends_on "pkgconf" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "gnupg"
  depends_on "hidapi"
  depends_on "libsodium" # for pynacl
  depends_on "libusb" => :no_linkage # for pyusb
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "aenum" do
    url "https://files.pythonhosted.org/packages/e3/52/6ad8f63ec8da1bf40f96996d25d5b650fdd38f5975f8c813732c47388f18/aenum-3.1.16-py3-none-any.whl"
    sha256 "9035092855a98e41b66e3d0998bd7b96280e85ceb3a04cc035636138a1943eaf"
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
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/a7/f6/d762df1f436a0618455d37f4e4c4872a7cd0dcfc8dec3022ee99e4389c69/cython-3.1.4.tar.gz"
    sha256 "9aefefe831331e2d66ab31799814eae4d0f8a2d246cbaaaa14d1be29ef777683"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4a/c0/89fe6215b443b919cb98a5002e107cb5026854ed1ccb6b5833e0768419d1/docutils-0.22.2.tar.gz"
    sha256 "9fdb771707c8784c8f2728b67cb2c691305933d68137ef95a75db5f4dfbc213d"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pymsgbox" do
    url "https://files.pythonhosted.org/packages/ae/6a/e80da7594ee598a776972d09e2813df2b06b3bc29218f440631dfa7c78a8/pymsgbox-2.0.1.tar.gz"
    sha256 "98d055c49a511dcc10fa08c3043e7102d468f5e4b3a83c6d3c61df722c7d798d"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/06/c6/a3124dee667a423f2c637cfd262a54d67d8ccf3e160f3c50f622a85b7723/pynacl-1.6.0.tar.gz"
    sha256 "cb36deafe6e2bce3b286e5d1f3e1c246e0ccdb8808ddb4550bb2792f2df298f2"
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
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
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
