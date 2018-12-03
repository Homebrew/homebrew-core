class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https://gettaurus.org"
  url "https://files.pythonhosted.org/packages/source/b/bzt/bzt-1.13.2.tar.gz"
  sha256 "939d8c51f9eeffe35813f3370e2a88b06fdfa0238b3201c43fbe178d444e1504"
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
    url "https://files.pythonhosted.org/packages/40/2f/1a7cc0b95fb1863443500138ac5c587462b679da2647f93ffa1aeb7c43e4/Appium-Python-Client-0.31.tar.gz"
    sha256 "54e57d5894070b62cf36b0c3805cce643980fee6561c9af97b5042d64e4d188f"
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
    url "https://files.pythonhosted.org/packages/55/54/3ce77783acba5979ce16674fc98b1920d00b01d337cfaaf5db22543505ed/certifi-2018.11.29.tar.gz"
    sha256 "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/76/53/e785891dce0e2f2b9f4b4ff5bc6062a53332ed28833c7afede841f46a5db/colorama-0.4.1.tar.gz"
    sha256 "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d"
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
    url "https://files.pythonhosted.org/packages/2d/80/1809de155bad674b494248bcfca0e49eb4c5d8bee58f26fe7a0dd45029e2/numpy-1.15.4.zip"
    sha256 "3d734559db35aa3697dadcea492a423118c5c55d176da2f3be9c98d4803fc2a7"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/bf/d7/a2568f4596b75d2c6e2b4094a7e64f620decc7887f69a1f2811931ea15b9/pathlib2-2.3.3.tar.gz"
    sha256 "25199318e8cc3c25dcb45cbe084cc061051336d5a9ea2a12448d3d8cb748f742"
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
    url "https://files.pythonhosted.org/packages/14/a2/8ac7dda36eac03950ec2668ab1b466314403031c83a95c5efc81d2acf163/psutil-5.4.5.tar.gz"
    sha256 "ebe293be36bb24b95cdefc5131635496e88b17fabbcf1e4bc9b5c01f5e489cfe"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/c7/fa/eb6dd513d9eb13436e110aaeef9a1703437a8efa466ce6bb2ff1d9217ac7/py-1.7.0.tar.gz"
    sha256 "bf92637198836372b520efcba9e020c330123be8ce527e535d185ed4b6f45694"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/24/f1/0e378fa418d9ac15d2d28296be916a55e351a6ffeb74105fe333c15ea58a/pytest-4.0.1.tar.gz"
    sha256 "1d131cc532be0023ef8ae265e2a779938d0619bb6c2510f52987ffcba7fa1ee4"
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
    url "https://files.pythonhosted.org/packages/40/35/298c36d839547b50822985a2cf0611b3b978a5ab7a5af5562b8ebe3e1369/requests-2.20.1.tar.gz"
    sha256 "ea881206e59f41dbd0bd445437d792e43906703fff75ca8ff43ccdb11f33f263"
  end

  resource "scandir" do
    url "https://files.pythonhosted.org/packages/16/2a/557af1181e6b4e30254d5a6163b18f5053791ca66e251e77ab08887e8fe3/scandir-1.9.0.tar.gz"
    sha256 "44975e209c4827fc18a3486f257154d34ec6eaec0f90fef0cca1caa482db7064"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/ed/9c/9030520bf6ff0b4c98988448a93c04fcbd5b13cd9520074d8ed53569ccfe/selenium-3.141.0.tar.gz"
    sha256 "deaf32b60ad91a4611b98d8002757f29e6f2c2d5fcaf202e1c9ad06d6772300d"
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
    url "https://files.pythonhosted.org/packages/bd/a8/45aa1c64f0aea4967766d9b46be3c0b03b096d8fb8c3cfe119884cfeed5e/texttable-1.5.0.tar.gz"
    sha256 "1ba399c103c825202659c4d638946c15ffc565ad7846ee0672964786f437fb57"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/c7/90/415728875c230fafd13d118512bde3184d810d7bf798a631abc05fac09d0/urwid-2.0.1.tar.gz"
    sha256 "644d3e3900867161a2fc9287a9762753d66bd194754679adb26aede559bcccbc"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/68/f0/545cbeae75f248c4ad7c2d062672cd7e046dd325a81b74fc02c62450d133/wheel-0.32.0.tar.gz"
    sha256 "a26bc27230baaec9039972b7cb43db94b17c13e4d66a9ff6a4d46a0344c55c9a"
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
