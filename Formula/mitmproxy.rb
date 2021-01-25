class Mitmproxy < Formula
  include Language::Python::Virtualenv

  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://github.com/mitmproxy/mitmproxy/archive/v6.0.2.tar.gz"
  sha256 "15b32ce31e707d35de1707afe09e82bbf3d643bdd93968c5512caba80523c606"
  license "MIT"
  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    cellar :any
    sha256 "94c020ab4dcc81788c9d2e9927fc473a2eab830bec0f6d8c70fb586d44abe0c9" => :big_sur
    sha256 "e31891ee528fab1b511d5430943c5d117f0a2c9666dd4da3af354058643d3c79" => :arm64_big_sur
    sha256 "f79b40c49e80b7f8857c97924838df92c840868ae747be9c3884486f2c17d9bf" => :catalina
    sha256 "5941b19532c712e0da05330230f5bc67d531a6c9864250ea6a3ecaaf72f3dc05" => :mojave
  end

  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python@3.9"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/e9/d1/096b5b0b411a1a53c294a508fdc51542de77bc193df5c8230ff9445e4ff3/asgiref-3.3.1.tar.gz"
    sha256 "7162a3cb30ab0609f1a4c95938fd73e8604f63bdba516a7f7d64b83ff09478f0"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1b/51/e2a9f3b757eb802f61dc1f2b09c8c99f6eb01cf06416c0671253536517b6/blinker-1.4.tar.gz"
    sha256 "471aee25f3992bd325afa3772f1063dbdbbca947a041b8b89466dc00d606f8b6"
  end

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/66/6a/98e023b3d11537a5521902ac6b50db470c826c682be6a8c661549cb7717a/cffi-1.14.4.tar.gz"
    sha256 "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/b7/82/f7a4ddc1af185936c1e4fa000942ffa8fb2d98cff26b75afa7b3c63391c4/cryptography-3.3.1.tar.gz"
    sha256 "7e177e4bea2de937a584b13645cab32f25e3d96fc0bc4a4cf99c27dc77682be6"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/4e/0b/cb02268c90e67545a0e3a37ea1ca3d45de3aca43ceb7dbf1712fb5127d5d/Flask-1.1.2.tar.gz"
    sha256 "4efa1ae2d7c9865af48986de8aeb8504bf32c7f3d6fdc9353d34b21f4b127060"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/22/01/01dc716e71eeead6c6329a19028548ac4a5c2a769a130722548c63479038/h11-0.11.0.tar.gz"
    sha256 "3c6c61d69c6f13d41f1b80ab0322f1872702a3ba26e12aa864c928f6a43fbaab"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/05/b8/cc1692aab910c0319b7c35e03c043bdda1cfeff67fa25b555eb2864a36e3/h2-4.0.0.tar.gz"
    sha256 "bb7ac7099dd67a857ed52c815a6192b6b1f5ba6b516237fc24a085341340593d"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/3e/9b/fda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954/hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/77/de/0b52ce363ab022f092abd82dca0f667a3b623f5f40d182e593fbc9113b4f/hyperframe-6.0.0.tar.gz"
    sha256 "742d2a4bc3152a340a49d59f32e33ec420aa8e7054c1444ef5c7efff255842f1"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/68/1a/f27de07a8a304ad5fa817bbe383d1238ac4396da447fa11ed937039fa04b/itsdangerous-1.1.0.tar.gz"
    sha256 "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "kaitaistruct" do
    url "https://files.pythonhosted.org/packages/33/e1/c75484bce13509d2bb1118585cd832cff228ed99df81753028dbf8f1dbcb/kaitaistruct-0.9.tar.gz"
    sha256 "3d5845817ec8a4d5504379cc11bd570b038850ee49c4580bc0998c8fb1d327ad"
  end

  resource "ldap3" do
    url "https://files.pythonhosted.org/packages/72/b9/b358e58d113928080b2cfaeb49078cdbcb33854886166afd325563219aef/ldap3-2.8.1.tar.gz"
    sha256 "37d633e20fa360c302b1263c96fe932d40622d0119f1bddcb829b03462eeeeb7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/1e/92/9a38750369d8f323d4ef31927119bfbc3d8bcce5b01f52950d873318b26b/msgpack-1.0.1.tar.gz"
    sha256 "7033215267a0e9f60f4a5e4fb2228a932c404f237817caff8dc3115d9e7cd975"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/12/ba/d6d9f1432663ab5623f761c86be11e7f2f6fb28348612f48fb082d3cfcea/protobuf-3.14.0.tar.gz"
    sha256 "1d63eb389347293d8915fb47bee0951c7b5dab522a4a60118b9a18f33e21f8ce"
  end

  resource "publicsuffix2" do
    url "https://files.pythonhosted.org/packages/5a/04/1759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20/publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/09/67/38a1080fabbb908515c47694238e00b6a73a82d9dbc76372263a231abfcb/pyOpenSSL-20.0.0.tar.gz"
    sha256 "92f08eccbd73701cf744e8ffd6989aa7842d48cbe3fea8a7c031c5647f590ac5"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/6f/4c/0b1d507ad7e8bc31d690d04b4f475e74c2002d060f7994ce8c09612df707/pyperclip-1.8.1.tar.gz"
    sha256 "9abef1e79ce635eb62309ecae02dfb5a3eb952fa7d6dce09c1aef063f81424d3"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/17/2f/f38332bf6ba751d1c8124ea70681d2b2326d69126d9058fbd9b4c434d268/ruamel.yaml-0.16.12.tar.gz"
    sha256 "076cc0bc34f1966d920a49f18b52b6ad559fbe656a0748e3535cf7b3f29ebf9e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/14/10/6a9481890bae97da9edd6e737c9c3dec6aea3fc2fa53b0934037b35c89ea/sortedcontainers-2.3.0.tar.gz"
    sha256 "59cc937650cf60d677c16775597c89a960658a09cf7c1a668f86e1e4464b10a1"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/cf/44/cc9590db23758ee7906d40cacff06c02a21c2a6166602e095a56cbf2f6f6/tornado-6.1.tar.gz"
    sha256 "33c6e81d7bd55b468d2e793517c909b139960b6c790a60b7991b9b6b76fb9791"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/10/27/a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04/Werkzeug-1.0.1.tar.gz"
    sha256 "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/2b/a4/aded0882f8f1cddd68dcd531309a15bf976f301e6a3554055cc06213c227/wsproto-1.0.0.tar.gz"
    sha256 "868776f8456997ad0d9720f7322b746bbe9193751b5b290b7f924659377c8c38"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/30/bb/551cd25042138bdd2c36168b837c4ed6196da58fa1cfe3d9de8e70ac23dc/zstandard-0.14.1.tar.gz"
    sha256 "5dd700e52ec28c64d43f681ccde76b6436c8f89a332d6c9e22a6b629f28daeb5"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("cffi")
    venv.pip_install resources
    venv.pip_install_and_link buildpath
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/mitmproxy --version 2>&1")
  end
end
