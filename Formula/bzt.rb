class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https://gettaurus.org"
  url "https://files.pythonhosted.org/packages/source/b/bzt/bzt-1.13.1.tar.gz"
  sha256 "bbc2620a1e6f4b015d338ce59e00f210a17f3d70598ec74719e3bb748ba049db"
  head "https://github.com/greyfenrir/taurus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed99f16ffcdc74fb312334d4e788cada64612677e6d3df6c58055d40420aea70" => :mojave
    sha256 "69ea52168eb17ce28f37fe02d7ee237876ff76e3f5c73c37e54f783accb8d325" => :high_sierra
    sha256 "8a953b33bfdee8cf2fbbcf542a8e7b2f3d6c8c68517f37a501537d49cc2426ac" => :sierra
  end

  depends_on "python@2"

  resource "apiritif" do
    url "https://files.pythonhosted.org/packages/3e/4d/cc49edec3128c558e6476da68d165f1614b9250bca538aa86af2476d842e/apiritif-0.6.7.tar.gz"
    sha256 "9667c04724aacf8f501f05178b6788dc138180c4909cb876a78d23b9a0f35af9"
  end

  resource "Appium-Python-Client" do
    url "https://files.pythonhosted.org/packages/65/f4/b31229c97ecd03015f2e2abd79ee998f0b91977062d559270abda9f1f3fe/Appium-Python-Client-0.28.tar.gz"
    sha256 "0d8f925a0cdb10346046ba200270b7dd6afc26eebebe34241769d92057f4ffec"
  end

  resource "astunparse" do
    url "https://files.pythonhosted.org/packages/14/53/3b080b8cff6a439d4371fcd02656b94b7325203b5c7f8cacc4789117b052/astunparse-1.6.1.tar.gz"
    sha256 "d27b16fb33dea0778c5a2c01801554eae0d3f8a8d6f604f15627589c3d6f11ca"
  end

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/ac/ed/a311712ef6b4355035489f665e63e1a73f9eb371929e3c98e5efd451069e/atomicwrites-1.2.1.tar.gz"
    sha256 "ec9ae8adaae229e4f8446952d204a3e4b5fdd2d099f9be3aaf556120135fb3ee"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/0f/9e/26b1d194aab960063b266170e53c39f73ea0d0d3f5ce23313e0ec8ee9bdf/attrs-18.2.0.tar.gz"
    sha256 "10cbf6e27dbce8c30807caf056c8eb50917e0eaafe86347671b57254006c3e69"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/b6/4f0cefba47656583217acd6cd797bc2db1fede0d53090fdc28ad2c8e0716/certifi-2018.10.15.tar.gz"
    sha256 "6d58c986d22b038c8c0df30d639f23a3e6d172a05c3583e766f4c0b785c0986a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/55/d5/c35bd3e63757ac767105f8695b055581d8b8dd8c22fef020ebefa2a3725d/colorama-0.4.0.zip"
    sha256 "c9b54bebe91a6a803e0772c8561d53f2926bfeb17cd141fbabcb08424086595c"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/2c/a8/8ce4f59cf1fcbb9ebe750fcbab723146d95687c37256ed367a11d9f74265/colorlog-3.1.4.tar.gz"
    sha256 "418db638c9577f37f0fae4914074f395847a728158a011be2a193ac491b9779d"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/52/ea/f31e1d2e9eb130fda2a631e22eac369dc644e8807345fbed5113f2d6f92b/cssselect-1.0.3.tar.gz"
    sha256 "066d8bc5229af09617e24b3ca4d52f1f9092d9e061931f4184cd572885c23204"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/6f/24/15a229626c775aae5806312f6bf1e2a73785be3402c0acdec5dbddd8c11e/decorator-4.3.0.tar.gz"
    sha256 "c39efa13fbdeb4506c476c9b3babf6a718da943dab7811c206005a4a956c080c"
  end

  resource "EasyProcess" do
    url "https://files.pythonhosted.org/packages/0d/f1/d2de7591e7dfc164d286fa16f051e6c0cf3141825586c3b04ae7cda7ac0f/EasyProcess-0.2.3.tar.gz"
    sha256 "94e241cadc9a46f55b5c06000df85618849602e7e1865b8de87576b90a22e61f"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "fuzzyset" do
    url "https://files.pythonhosted.org/packages/92/21/4939957d219ff9f88b3b120061282199eda0ddd7393732a8c15cfcf51253/fuzzyset-0.0.15.tar.gz"
    sha256 "861f156d69bfe22096047b8c07c8cbc78291022f4dabe55b81d2bd8235eb4402"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/10/c1/9499b146bfa43aa4f1e0ed1bab1bd3209a4861d25650c11725036c731cf5/gevent-1.3.7.tar.gz"
    sha256 "3f06f4802824c577272960df003a304ce95b3e82eea01dad2637cc8609c80e2c"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/f8/e8/b30ae23b45f69aa3f024b46064c0ac8e5fcb4f22ace0dca8d6f9c8bbe5e7/greenlet-0.4.15.tar.gz"
    sha256 "9416443e219356e3c31f1f918a91badf2e37acf297e2fa13d24d1cc2380f8fbc"
  end

  resource "hdrpy" do
    url "https://files.pythonhosted.org/packages/47/8c/159be762f787888651f9895a60d8564d2c1df5b2581cc733823b45759cfd/hdrpy-0.3.3.tar.gz"
    sha256 "8461ed2c0d577468e5499f8b685d9bf9660b72b8640bff02c78ba1f1b9bf5185"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/97/8d/77b8cedcfbf93676148518036c6b1ce7f8e14bf07e95d7fd4ddcb8cc052f/ipaddress-1.0.22.tar.gz"
    sha256 "b146c751ea45cad6188dd6cf2d9b757f6f4f8d6ffb96a023e6f2e26eea02a72c"
  end

  resource "jsonpath-rw" do
    url "https://files.pythonhosted.org/packages/71/7c/45001b1f19af8c4478489fbae4fc657b21c4c669d7a5a036a86882581d85/jsonpath-rw-1.4.0.tar.gz"
    sha256 "05c471281c45ae113f6103d1268ec7a4831a2e96aa80de45edc89b11fac4fbec"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/4b/20/ddf5eb3bd5c57582d2b4652b4bbcf8da301bdfe5d805cb94e805f4d7464d/lxml-4.2.5.tar.gz"
    sha256 "36720698c29e7a9626a0dc802ef8885f8f0239bfd1689628ecd459a061f2807f"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/88/ff/6d485d7362f39880810278bdc906c13300db05485d9c65971dec1142da6a/more-itertools-4.3.0.tar.gz"
    sha256 "c476b5d3a34e12d40130bc2f935028b5f636df8f372dc2c1c01dc19681b2039e"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/83/6b/d03277eacf113697675cd659086a4dcf9472108e2f1a83884c0271bdca46/numpy-1.15.3.zip"
    sha256 "1c0c80e74759fa4942298044274f2c11b08c86230b25b8b819e55e644f5ff2b6"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/db/a8/7d6439c1aec525ed70810abee5b7d7f3aa35347f59bc28343e8f62019aa2/pathlib2-2.3.2.tar.gz"
    sha256 "8eb170f8d0d61825e09a95b38be068299ddeda82f35e96c3301a8a5e7604cb83"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/65/25/81d0de17cd00f8ca994a4e74e3c4baf7cd25072c0b831dad5c7d9d6138f8/pluggy-0.8.0.tar.gz"
    sha256 "447ba94990e8014ee25ec853339faf7b0fc8050cdc3289d4d71f7f410fb90095"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "progressbar33" do
    url "https://files.pythonhosted.org/packages/71/fc/7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6b/progressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/7d/9a/1e93d41708f8ed2b564395edfa3389f0fd6d567597401c2e5e2775118d8b/psutil-5.4.7.tar.gz"
    sha256 "5b6322b167a5ba0c5463b4d30dfd379cd4ce245a1162ebf8fc7ab5c5ffae4f3b"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/c7/fa/eb6dd513d9eb13436e110aaeef9a1703437a8efa466ce6bb2ff1d9217ac7/py-1.7.0.tar.gz"
    sha256 "bf92637198836372b520efcba9e020c330123be8ce527e535d185ed4b6f45694"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/28/09/f73d49a5b0b714e2d4712f044686cb8fa954aac15f4b7ea557049210179f/pytest-3.9.3.tar.gz"
    sha256 "a9e5e8d7ab9d5b0747f37740276eb362e6a76275d76cebbb52c6049d93b475db"
  end

  resource "python-Levenshtein" do
    url "https://files.pythonhosted.org/packages/42/a9/d1785c85ebf9b7dfacd08938dd028209c34a0ea3b1bcdb895208bd40a67d/python-Levenshtein-0.12.0.tar.gz"
    sha256 "033a11de5e3d19ea25c9302d11224e1a1898fe5abd23c61c7c360c25195e3eb1"
  end

  resource "PyVirtualDisplay" do
    url "https://files.pythonhosted.org/packages/39/37/f285403a09cc261c56b6574baace1bdcf4b8c7428c8a7239cbba137bc0eb/PyVirtualDisplay-0.2.1.tar.gz"
    sha256 "012883851a992f9c53f0dc6a512765a95cf241bdb734af79e6bdfef95c6e9982"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/97/10/92d25b93e9c266c94b76a5548f020f3f1dd0eb40649cb1993532c0af8f4c/requests-2.20.0.tar.gz"
    sha256 "99dcfdaaeb17caf6e526f32b6a7b780461512ab3f1d992187801694cba42770c"
  end

  resource "scandir" do
    url "https://files.pythonhosted.org/packages/16/2a/557af1181e6b4e30254d5a6163b18f5053791ca66e251e77ab08887e8fe3/scandir-1.9.0.tar.gz"
    sha256 "44975e209c4827fc18a3486f257154d34ec6eaec0f90fef0cca1caa482db7064"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/75/c4/e361c5659c558edbd391d322622d8d37ae1cf011cf42470455d54956a80f/selenium-3.14.1.tar.gz"
    sha256 "ab192cd046164c40fabcf44b47c66c8b12495142f4a69dcc55ea6eeef096e614"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/4d/35/88cd3b6c9cfe79f98fa52a57843fc6501988b9da13dce1e6a27e1d70d357/texttable-1.4.0.tar.gz"
    sha256 "95e8cfe85f8395a7eacdfbc8f09d885b9ef3a6ac6ead0364ea721de1127aa36b"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/a5/74/05ffd00b4b5c08306939c485869f5dc40cbc27357195b0a98b18e4c48893/urllib3-1.24.tar.gz"
    sha256 "41c3db2fc01e5b907288010dec72f9d0a74e37d6994e6eb56849f59fea2265ae"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/c7/90/415728875c230fafd13d118512bde3184d810d7bf798a631abc05fac09d0/urwid-2.0.1.tar.gz"
    sha256 "644d3e3900867161a2fc9287a9762753d66bd194754679adb26aede559bcccbc"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c2/00/21e3ecc8a9d484f9de995471c061aa3d8f02ae54bdfd9cbdddb59138c809/wheel-0.32.2.tar.gz"
    sha256 "196c9842d79262bb66fcf59faa4bd0deb27da911dbc7c6cdca931080eb1f0783"
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
