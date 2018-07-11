class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https://gettaurus.org"
  url "https://files.pythonhosted.org/packages/source/b/bzt/bzt-1.12.1.tar.gz"
  sha256 "9c61be44a6d5d88dc925da71fe59bf7bc8dbf9f43ff43352e5e0e77004ccfef9"
  head "https://github.com/greyfenrir/taurus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a58118503240e8a7b05d81090dc53d9f09388add26433c5af6bc7732c3d1220" => :high_sierra
    sha256 "9d4620fcab2fba12ffa711ebf90f4c4c22905e90cdc091ad4daf6ad826cf7901" => :sierra
    sha256 "67f7d63147b2faf6cd6123f5e1888584fd8d0591413f4fe5bdebf30b6e29bdce" => :el_capitan
  end

  depends_on "python@2"

  resource "apiritif" do
    url "https://files.pythonhosted.org/packages/a7/7f/66ab907fb72867e34ca114ddc369ac892abac94a1005ff8c22739fafb341/apiritif-0.6.5.tar.gz"
    sha256 "81c9883c3d60ffbd5111316878fdf4dd7b97075aaba107db29992a1b76057686"
  end

  resource "Appium-Python-Client" do
    url "https://files.pythonhosted.org/packages/51/a6/beabf895cd0f87a9f2bfcb641e250a55ee289056a256fa34bf38c65c47b9/Appium-Python-Client-0.27.tar.gz"
    sha256 "25b87075d1e0b33c1eda2f40681f454abd3920b883d1e57cef72e475817f6bc5"
  end

  resource "astunparse" do
    url "https://files.pythonhosted.org/packages/1a/b7/3ba7ce33cbc8847e20ed1a4fbec2303a71b2512dec0194824e8dcaadc8de/astunparse-1.5.0.tar.gz"
    sha256 "55df3c2a659d6cb6a9a9041c750a8232a9925523405a8dfeb891b92d45a589cd"
  end

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/a1/e1/2d9bc76838e6e6667fde5814aa25d7feb93d6fa471bf6816daac2596e8b2/atomicwrites-1.1.5.tar.gz"
    sha256 "240831ea22da9ab882b551b31d4225591e5e447a68c5e188db5b89ca1d487585"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e4/ac/a04671e118b57bee87dabca1e0f2d3bda816b7a551036012d0ca24190e71/attrs-18.1.0.tar.gz"
    sha256 "e0d0eb91441a3b53dab4d9b743eafc1ac44476296a2053b6ca3af0b139faf87b"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"
    sha256 "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"
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

  resource "hdrpy" do
    url "https://files.pythonhosted.org/packages/bd/d7/e8ca5e656d71aa05a89402982907ef3110d7a5792cb0f422de75029ff766/hdrpy-0.3.2.tar.gz"
    sha256 "beb0803f401acd6f4a57aca7a2cb62212418849a8dad4be1ff5df323ec0b85d2"
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
    url "https://files.pythonhosted.org/packages/54/a6/43be8cf1cc23e3fa208cab04ba2f9c3b7af0233aab32af6b5089122b44cd/lxml-4.2.3.tar.gz"
    sha256 "622f7e40faef13d232fb52003661f2764ce6cdef3edb0a59af7c1559e4cc36d1"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/c0/2f/6773347277d76c5ade4414a6c3f785ef27e7f5c4b0870ec7e888e66a8d83/more-itertools-4.2.0.tar.gz"
    sha256 "2b6b9893337bfd9166bee6a62c2b0c9fe7735dcf85948b387ec8cba30e85d8e8"
  end

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/d5/6e/f00492653d0fdf6497a181a1c1d46bbea5a2383e7faf4c8ca6d6f3d2581d/numpy-1.14.5.zip"
    sha256 "a4a433b3a264dbc9aa9c7c241e87c0358a503ea6394f8737df1683c7c9a102ac"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/11/bf/cbeb8cdfaffa9f2ea154a30ae31a9d04a1209312e2919138b4171a1f8199/pluggy-0.6.0.tar.gz"
    sha256 "7f8ae7f5bdf75671a718d2daf0a64b7885f74510bcd98b1a0bb420eb9a9d0cff"
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
    url "https://files.pythonhosted.org/packages/51/9e/0f8f5423ce28c9109807024f7bdde776ed0b1161de20b408875de7e030c3/psutil-5.4.6.tar.gz"
    sha256 "686e5a35fe4c0acc25f3466c32e716f2d498aaae7b7edc03e2305b682226bcf6"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/35/77/a0a2a4126cf454e6ac772942898379e2fe78f2b7885df0461a5b8f8a8040/py-1.5.4.tar.gz"
    sha256 "3fd59af7435864e1a243790d322d763925431213b6b8529c6ca71081ace3bbf7"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/55/50/399419c03c39bf41faa7cbd5a8976c076037b2d76adf2535610919806d67/pytest-3.6.3.tar.gz"
    sha256 "0453c8676c2bee6feb0434748b068d5510273a916295fd61d306c4f22fbfd752"
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
    url "https://files.pythonhosted.org/packages/54/1f/782a5734931ddf2e1494e4cd615a51ff98e1879cbe9eecbdfeaf09aa75e9/requests-2.19.1.tar.gz"
    sha256 "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/6d/4b/30b28589f2b6051b04d6f8014537749dc08fa787a5569cebb33e892d34d3/selenium-3.13.0.tar.gz"
    sha256 "f35bb209cab740c195276a323c1b750dbcfdb9f6983e7d6e3abba9cd8838f355"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"
    sha256 "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/c7/90/415728875c230fafd13d118512bde3184d810d7bf798a631abc05fac09d0/urwid-2.0.1.tar.gz"
    sha256 "644d3e3900867161a2fc9287a9762753d66bd194754679adb26aede559bcccbc"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/2a/fb/aefe5d5dbc3f4fe1e815bcdb05cbaab19744d201bbc9b59cfa06ec7fc789/wheel-0.31.1.tar.gz"
    sha256 "0a2e54558a0628f2145d2fc822137e322412115173e8a2ddbe1c9024338ae83c"
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
