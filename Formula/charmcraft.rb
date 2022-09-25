class Charmcraft < Formula
  include Language::Python::Virtualenv

  desc "Tool to build charms and publish them on Charmhub"
  homepage "https://charmhub.io"
  url "https://files.pythonhosted.org/packages/29/29/1344f690c2bd5e4f54491817252681894bdb7bff56a80372db11b3b4618e/charmcraft-2.0.0.tar.gz"
  sha256 "d948a31c3cfd6e4608ecb775b8ac3285342cd4149ba5760cebbae36a196bd74a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "793fe492b2fae8e18a557124cc79c9f71fd4700329e2c8e3f76acf48fe3552e7"
    sha256 cellar: :any,                 arm64_big_sur:  "d71d17ad6672fbd5fce8ec7952d73d2b18ed9bc91cb49267e079eed4295f97b7"
    sha256 cellar: :any,                 monterey:       "f3873461565c4e5627fe8d44ec4af00505e9d3cdce56f012056acc7ec90609ac"
    sha256 cellar: :any,                 big_sur:        "5a9bf6c2cb7683533bf2b55764932ef0e548f17fe53f8eaf8894e20ad3d11a87"
    sha256 cellar: :any,                 catalina:       "3d8c2c1611251aa6f7ccd818e266eddf5b24c8b8638863060660c88fba482349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557b8b763b671c4b7cc59d0c669572005b5aefdbe57f88429fa683ef7e0bb971"
  end

  depends_on "rust" => :build
  depends_on "jsonschema"
  depends_on "libpython-tabulate"
  depends_on "libsodium"
  depends_on "python-typing-extensions"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "craft-cli" do
    url "https://files.pythonhosted.org/packages/09/1e/1689620a55fef90154191e750cafc1b86c311bb4b3ad7e3d55fe67012d34/craft-cli-1.1.0.tar.gz"
    sha256 "a0c4aecbade5f614e0f2662f6ef648ffde374ec2e0722e077c30a6f228c3cb1c"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/fe/6d/e39687d60203551d5666f0576943cd97944096e3d2675a38cece42340e90/craft-parts-1.10.2.tar.gz"
    sha256 "f64e4c8efce87900b2ce407a519ea88f4329cba7969da8226a5deb1955b8a2a0"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/ad/e4/7037f3b9a08210357db0b2bf30b759217a8bb06d8b62f52f6b236a510781/craft-providers-1.3.1.tar.gz"
    sha256 "a5a482daaf88578c2481b359efeb8b2bcb78bbd8a355a196109d881194d60421"
  end

  resource "craft-store" do
    url "https://files.pythonhosted.org/packages/54/61/4dd962029d8cf728a0ca1a9d0713c600026192f17a4e652b71fe1b1c9857/craft-store-2.1.1.tar.gz"
    sha256 "458a19d65e3ee76dbff81e569edc6e7e3def0a2e30b16c0b94672296b9f2360b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ea/d8/2afd2890fe451a3c109d2bdb6bc4ded55ec43059e524344d5e0004e36412/cryptography-3.4.tar.gz"
    sha256 "9f7aa11ea95723359f914be3217d8b378bc3897f65a1ec1ab4e0118c336f51fc"
  end

  resource "Deprecated" do
    url "https://files.pythonhosted.org/packages/c8/d1/e412abc2a358a6b9334250629565fe12697ca1cdee4826239eddf944ddd0/Deprecated-1.2.13.tar.gz"
    sha256 "43ac5335da90c31c24ba028af536a91d41d53f9e6901ddb021bcc572ce44e38d"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/a0/0e/93e7c308611ff2ac3142dd5b1cef6bc02364affae21ba84342896470a868/humanize-4.3.0.tar.gz"
    sha256 "0dfac79fe8c1c0c734c14177b07b857bad9ae30dd50daa0a14e2c3d8054ee0c4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/01/92/9a1973e6132089e1263b0dc545a021d0733bf5d5b6fa19cc7e641e1925ae/keyring-23.7.0.tar.gz"
    sha256 "782e1cd1132e91bf459fcd243bcf25b326015c1ac0b198e4408f91fa6791062b"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/52/40/2a8bb2f507ce1a6c5b896c1b98044d74d34b07a6dd771526b4fe84e3181f/macaroonbakery-1.3.1.tar.gz"
    sha256 "23f38415341a1d04a155b4dac6730d3ad5f39b86ce07b1bb134bdda52b48b053"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/91/61/79f6f13e322f0093a7fc1ae99fef15236f43589373beee5982bfd0b69fa9/overrides-6.2.0.tar.gz"
    sha256 "e15c1a7d9a605999507a5e17d36505319f9e971cbcbde37b507c84346318301b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/19/96/1283259c25bc48a6df98fa096f66fc568b40137b93806ef5ff66a2d166b1/protobuf-3.20.1.tar.gz"
    sha256 "adc31566d027f45efe3f44eeb5b1f329da43891634d61c75a5944e9be6dd42c9"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/60/a3/23a8a9378ff06853bda6527a39fe317b088d760adf41cf70fc0f6110e485/pydantic-1.9.0.tar.gz"
    sha256 "742645059757a56ecd886faf4ed2441b9c0cd406079c2b4bee51bcc3fbcd510a"
  end

  resource "pydantic-yaml" do
    url "https://files.pythonhosted.org/packages/ea/06/e16bb162a9edbf15c1a821528c107f25e8434dd4a9f5261c43c20ccac7c5/pydantic_yaml-0.8.0.tar.gz"
    sha256 "324d75c84c068f64fefd5910967a83735231296c8eaba0dd48d721b7eccae8db"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/c3/ea/0fb87f844d8a35ff0dcc8b941e1a9ffc9eb46588ac9e4267b9d9804354eb/requests-unixsocket-0.3.0.tar.gz"
    sha256 "28304283ea9357d45fff58ad5b11e47708cfbf5806817aa59b2a363228ee971e"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/ed/c6/8effd679eb1cb6d3fd9fc7837cf86c6e4c1ba7a33c3e5e35c741c04016c5/setuptools-rust-1.4.1.tar.gz"
    sha256 "18ff850831f58ee21d5783825c99fad632da21e47645e9427fd7dec048029e76"
  end

  resource "snap-helpers" do
    url "https://files.pythonhosted.org/packages/54/a4/7f11eb8d96826cfe17c4c68b907f8005d97ad1ef23dea67aa3d39287f6d7/snap-helpers-0.2.0.tar.gz"
    sha256 "e72c810af32a0126bfcb7d5c39dda5ca2037889ca2fe2ee5aa543a25b9ca670b"
  end

  resource "types-Deprecated" do
    url "https://files.pythonhosted.org/packages/45/2f/c0e57815699277d3ecb3cc974c4ffee0afc37a593437328766a42a525dd2/types-Deprecated-1.2.9.tar.gz"
    sha256 "e04ce58929509865359e91dcc38720123262b4cd68fa2a8a90312d50390bb6fa"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/6d/d5/e8258b334c9eb8eb78e31be92ea0d5da83ddd9385dc967dd92737604d239/urllib3-1.26.11.tar.gz"
    sha256 "ea6e8fb210b19d950fab93b60c9009226c63a28808bc8386e05301e25883ac0a"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"charmcraft", "version"
    system bin/"charmcraft", "help"
    system bin/"charmcraft", "init", "--author", "Foo Bar", "-p", testpath/"charm"
    assert_predicate testpath/"charm/charmcraft.yaml", :exist?
  end
end
