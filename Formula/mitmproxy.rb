class Mitmproxy < Formula
  include Language::Python::Virtualenv

  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://github.com/mitmproxy/mitmproxy/archive/v8.0.0.tar.gz"
  sha256 "9bf403660169327e1b9c8b1701f9f45923e72eba935005cb357f1f4bca1815b5"
  license "MIT"
  head "https://github.com/mitmproxy/mitmproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "82720389d6d732a203539de6208e87b071ed5dec58d5e5cb8fbb832a4b765e9e"
    sha256 cellar: :any,                 arm64_big_sur:  "0e802ad765b310514bfbe6b5a34b2a3c85a3657374cd188304cb34eaa57efcb1"
    sha256 cellar: :any,                 monterey:       "acf6124d1a71b344133bb68e008f172b3d2f8808c81a2e78897c15c8640941af"
    sha256 cellar: :any,                 big_sur:        "967a1e2dee1979e09840d1198d1e62d5a3bd0c4fcb8a5694bbf1b1edd7281044"
    sha256 cellar: :any,                 catalina:       "f8b83e857b89e36ac9e4a0942e4e41fbf7819a16bc5c5460d6df341fb76e648c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de0f52599abb7474932540d9a1a9fe9f2275504beefd052f6b3094974e97669e"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/ea/2b/3face3a7241f61dc1c58dbe243cc02c15c61ccdcafebc4406f7bb40ce731/asgiref-3.5.0.tar.gz"
    sha256 "2f8abc20f7248433085eda803936d98992f1343ddb022065779f37c5da0181d0"
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
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/84/9d/66347e6b3e2eb78647392d3969c23bdc2d8b2fdc32bd078c817c15cb81ad/Flask-2.0.3.tar.gz"
    sha256 "e1120c228ca2f553b470df4a5fa927ab66258467526069981b3eb0a91902687d"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/fa/a6/450568b2d62dd633be53f69890332bb0ce78183ffbe1e514c2b3102efff5/h11-0.13.0.tar.gz"
    sha256 "70813c1135087a248a4d38cc0e1a0181ffab2188141a93eaf567940c3957ff06"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/2a/32/fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1/h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/3e/9b/fda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954/hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/5a/2a/4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebb/hyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9d/86/39f81e23f49eaf62d22248d48771dbf3bce7c52dfdf566e3d8d4c0657f15/itsdangerous-2.1.1.tar.gz"
    sha256 "7b7d3023cd35d9cb0c1fd91392f8c95c6fa02c59bf8ad64b8849be3401b95afb"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "kaitaistruct" do
    url "https://files.pythonhosted.org/packages/33/e1/c75484bce13509d2bb1118585cd832cff228ed99df81753028dbf8f1dbcb/kaitaistruct-0.9.tar.gz"
    sha256 "3d5845817ec8a4d5504379cc11bd570b038850ee49c4580bc0998c8fb1d327ad"
  end

  resource "ldap3" do
    url "https://files.pythonhosted.org/packages/43/ac/96bd5464e3edbc61595d0d69989f5d9969ae411866427b2500a8e5b812c0/ldap3-2.9.1.tar.gz"
    sha256 "f3e7fc4718e3f09dda568b57100095e0ce58633bcabbed8667ce3f8fbaa4229f"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/61/3c/2206f39880d38ca7ad8ac1b28d2d5ca81632d163b2d68ef90e46409ca057/msgpack-1.0.3.tar.gz"
    sha256 "51fdc7fb93615286428ee7758cecc2f374d5ff363bdd884c7ea622a7a327a81e"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
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
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/35/d3/d6a9610f19d943e198df502ae660c6b5acf84cc3bc421a2aa3c0fb6b21d1/pyOpenSSL-22.0.0.tar.gz"
    sha256 "660b1b1425aac4a1bea1d94168a85d99f0b3144c869dd4390d27629d0087f1bf"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
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
    url "https://files.pythonhosted.org/packages/6c/a8/60514fade2318e277453c9588545d0c335ea3ea6440ce5cdabfca7f73117/Werkzeug-2.0.3.tar.gz"
    sha256 "b863f8ff057c522164b6067c9e28b041161b4be5ba4d0daceeaa50a163822d3c"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/f5/58/575e416cd024d23c52de9e17d02f4c5ef4a9c8a7258c6fc8f2b3f96f73cf/wsproto-1.1.0.tar.gz"
    sha256 "a2e56bfd5c7cd83c1369d83b5feccd6d37798b74872866e62616e0ecf111bda8"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/55/29/a4dc59d4df31a5797b07d83a0e53137f6dcd1be0c9ac1e4dbcaac8522a11/zstandard-0.17.0.tar.gz"
    sha256 "fa9194cb91441df7242aa3ddc4cb184be38876cb10dd973674887f334bafbfb6"
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
