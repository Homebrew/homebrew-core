class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https://gettaurus.org/"
  url "https://files.pythonhosted.org/packages/88/56/7f7d9eafbf7d8ec556be274727cc0c178195e613e220c1ef5441e5387370/bzt-1.16.1.tar.gz"
  sha256 "8abeef230a2144b9bbf07444dab6cceb48f926c39b5292944af0cb7beb5e546c"
  license "Apache-2.0"
  head "https://github.com/Blazemeter/taurus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "585200d41eb806aec9f03054542729bc79ef6a6d89ee3bebfdbfa79442699f7d"
    sha256 cellar: :any,                 arm64_big_sur:  "ad8b1e275eb1316347115f4d38dce5685a0478bfa320ab9d001d8409f609432c"
    sha256 cellar: :any,                 monterey:       "bddaf912e0e859f36d59e28dfc5a10e338f345e7ee4bff9a98a93fd8399a46c5"
    sha256 cellar: :any,                 big_sur:        "a67cf1fc3c2c2a0d712e888892ed9c98c332ecbd236331acbe910bcfa14e2b8e"
    sha256 cellar: :any,                 catalina:       "97357518845764ac60d494138448f3e061a73e90a275ea5c2d55e9804583bf8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a14814424defacd54f911cda4e8130842363f08df94668bdfe78b3a1ca5eafa"
  end

  depends_on "rust" => :build
  depends_on "numpy"
  depends_on "python@3.9"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "aiodogstatsd" do
    url "https://files.pythonhosted.org/packages/5d/97/7c671c6f6007aab9864787c9cf2ac7f97c04b928711312d41c9748a09691/aiodogstatsd-0.15.0.tar.gz"
    sha256 "f315ef90510440c2653c7123ddeb67163425cf35ebd39690e921b812c75dfdb8"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/5a/86/5f63de7a202550269a617a5d57859a2961f3396ecd1739a70b92224766bc/aiohttp-3.8.1.tar.gz"
    sha256 "fc5471e1a54de15ef71c1bc6ebe80d4dc681ea600e68bfd1cbce40427f0b7578"
  end

  resource "aiomeasures" do
    url "https://files.pythonhosted.org/packages/04/56/be4bdc775a07e79bd5fdbfe6d02aad5ae6b78a7137437deabc2c72148f06/aiomeasures-0.5.14.tar.gz"
    sha256 "37a802d3149b034647cf5917cbc83e00dde4fa1fdb922faed26721f448ee1ed5"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/27/6b/a89fbcfae70cf53f066ec22591938296889d3cc58fec1e1c393b10e8d71d/aiosignal-1.2.0.tar.gz"
    sha256 "78ed67db6c7b7ced4f98e495e572106d5c432a93e1ddd1bf475e1dc05f5b7df2"
  end

  resource "astunparse" do
    url "https://files.pythonhosted.org/packages/f3/af/4182184d3c338792894f34a62672919db7ca008c89abee9b564dd34d8029/astunparse-1.6.3.tar.gz"
    sha256 "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/ce/cf/9452ab2a5936f96aa94e3c1cf21e8038b643cd27f33aeebc3aea5d25bcd1/async-timeout-4.0.1.tar.gz"
    sha256 "b930cb161a39042f9222f6efb7301399c87eeab394727ec5437924a36d6eef51"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/68/e4/e014e7360fc6d1ccc507fe0b563b4646d00e0d4f9beec4975026dd15850b/charset-normalizer-2.0.9.tar.gz"
    sha256 "b0b883e8e874edfdece9c28f314e3dd5badf067342e42fb162203335ae61aa2c"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8e/8f/1537ebed273d43edd3bb21f1e5861549b7cfcb1d47523d7277cab988cec2/colorlog-6.6.0.tar.gz"
    sha256 "344f73204009e4c83c5b6beb00b3c45dc70fcdae3c80db919e0a4171d006fde8"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/02/a8/5fae273a45a3e4e34ea560c99a4843fe2d9fc6fb691de064dc9c72c46e57/configparser-5.2.0.tar.gz"
    sha256 "1b35798fdf1713f1c3139016cfcbc461f09edbf099d1fb658d4b7479fcaa3daa"
  end

  resource "crayons" do
    url "https://files.pythonhosted.org/packages/b8/6b/12a1dea724c82f1c19f410365d3e25356625b48e8009a7c3c9ec4c42488d/crayons-0.4.0.tar.gz"
    sha256 "bd33b7547800f2cfbd26b38431f9e64b487a7de74a947b0fafc89b45a601813f"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz"
    sha256 "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc"
  end

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/09/45/10c39337ba73c38a798165f97e4798827a532eaac71071842cbe0ee13dc5/Cython-0.29.25.tar.gz"
    sha256 "a87cbe3756e7c464acf3e9420d8741e62d3b2eace0846cb39f664ad378aab284"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/57/b7/c4aa04a27040e6a3b09f5a652976ead00b66504c014425a7aad887aa8d7f/dill-0.3.4.zip"
    sha256 "9f9734205146b2b353ab3fec9af0070237b6ddae78452af83d2fca84d739e675"
  end

  resource "EasyProcess" do
    url "https://files.pythonhosted.org/packages/df/08/aed1831e26e275886a0ca9e5f7a50d0213c5c53c3f559dd8b85b68dbc2b3/EasyProcess-0.3.tar.gz"
    sha256 "fb948daac01f64c1e49750752711253614846c6fc7e5692a718a7408f2ffb984"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/5c/ee/7c6287928ba776567603248e160387cf4143641ecf734e393ad9b2c82475/frozenlist-1.2.0.tar.gz"
    sha256 "68201be60ac56aff972dc18085800b6ee07973c49103a8aba669dee3d71079de"
  end

  resource "fuzzyset2" do
    url "https://files.pythonhosted.org/packages/cd/57/6eba745dd426f14508d46a113deba642a4c0078f7041bfd974a16c9fbeac/fuzzyset2-0.1.1.tar.gz"
    sha256 "572c53a1f09d8d6c5b8b012b7b699327834c2d892a48e3d66ec650458a19614e"
  end

  resource "hdrpy" do
    url "https://files.pythonhosted.org/packages/47/8c/159be762f787888651f9895a60d8564d2c1df5b2581cc733823b45759cfd/hdrpy-0.3.3.tar.gz"
    sha256 "8461ed2c0d577468e5499f8b685d9bf9660b72b8640bff02c78ba1f1b9bf5185"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/fe/4c/a4dbb4e389f75e69dbfb623462dfe0d0e652107a95481d40084830d29b37/lxml-4.6.4.tar.gz"
    sha256 "daf9bd1fee31f1c7a5928b3e1059e09a8d683ea58fb3ffc773b6c88cb8d1399c"
  end

  resource "molotov" do
    url "https://files.pythonhosted.org/packages/f6/c7/11ffa035894597bff22731082b27e2d9406b0a09f45fd0991f8148d6017e/molotov-2.3.tar.gz"
    sha256 "c9777d1bbbd952cdcf14e59d85d1085d0e9bfe4e12acc68008e8a97050b72edc"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/8e/7c/e12a69795b7b7d5071614af2c691c97fbf16a2a513c66ec52dd7d0a115bb/multidict-5.2.0.tar.gz"
    sha256 "0dd1c93edb444b33ba2274b66f63def8a327d607c6c790772f448a53b6ea59ce"
  end

  resource "multiprocessing_on_dill" do
    url "https://files.pythonhosted.org/packages/86/4d/4b135e2e5cd0194eb29f2ed36e9a77a07596787a9a8ac2279bd4445398f2/multiprocessing_on_dill-3.5.0a4.tar.gz"
    sha256 "d6d50c300ff4bd408bb71eb78725e60231039ee9b3d0d9bb7697b9d0e15045e7"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/fb/48/b0708ebd7718a8933f0d3937513ef8ef2f4f04529f1f66ca86d873043921/numpy-1.21.4.zip"
    sha256 "e6c76a87633aa3fa16614b61ccedfae45b91df2767cf097aa9c933932a7ed1e0"
  end

  resource "progressbar33" do
    url "https://files.pythonhosted.org/packages/71/fc/7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6b/progressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "python-Levenshtein" do
    url "https://files.pythonhosted.org/packages/2a/dc/97f2b63ef0fa1fd78dcb7195aca577804f6b2b51e712516cc0e902a9a201/python-Levenshtein-0.12.2.tar.gz"
    sha256 "dc2395fbd148a1ab31090dd113c366695934b9e85fe5a4b2a032745efd0346f6"
  end

  resource "PyVirtualDisplay" do
    url "https://files.pythonhosted.org/packages/2f/3d/d0edda70805ac705b09bc0183fb596f0323b0833399dae1799f7d7e251f4/PyVirtualDisplay-2.2.tar.gz"
    sha256 "3ecda6b183b03ba65dcfdf0019809722480d7b7e10eea6e3a40bf1ba3146bab7"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/f5/fc/0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3/terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0d/4a/60ba3706797b878016f16edc5fbaf1e222109e38d0fa4d7d9312cb53f8dd/typing_extensions-4.0.1.tar.gz"
    sha256 "4ca091dea149f945ec56afb48dae714f21e8692ef22a395223bcd328961b6a0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  resource "webdriver-manager" do
    url "https://files.pythonhosted.org/packages/96/b1/8276eb8b34dcbeb3fd1aadfd6341c3133b00f26f30e76559507ad2f6ef90/webdriver_manager-3.5.2.tar.gz"
    sha256 "0a0df5e5d5d234702fd5948fec6c3884940aff904425725f15d8bb9eeaee18e8"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/4e/be/8139f127b4db2f79c8b117c80af56a3078cc4824b5b94250c7f81a70e03b/wheel-0.37.0.tar.gz"
    sha256 "e2ef7239991699e3355d54f8e968a21bb940a1dbf34a4d226741e64462516fad"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/f6/da/46d1b3d69a9a0835dabf9d59c7eb0f1600599edd421a4c5a15ab09f527e0/yarl-1.7.2.tar.gz"
    sha256 "45399b46d60c253327a460e99856752009fcee5f5d3c80b2f7c0cae1c38d56dd"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    virtualenv_install_with_resources

    # remove non-native binary
    (libexec/"lib/python3.9/site-packages/selenium/webdriver/firefox/x86/x_ignore_nofocus.so").unlink if OS.linux?
  end

  test do
    cmd = "#{bin}/bzt -v -o execution.executor=apiritif -o execution.iterations=1 -o execution.scenario.requests.0=https://gettaurus.org/"
    # assert_match /INFO: Samples count: 1, .*% failures/, shell_output(cmd)
    system(cmd)
  end
end
