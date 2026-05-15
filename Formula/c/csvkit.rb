class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/9a/bf/59b035abead12d9498c96dc05b965ec77683d3c794305dec2648e23830cc/csvkit-2.2.0.tar.gz"
  sha256 "147318a8dbaec07c0bbb9291c14b78de5fa32ed3d4a5c2396e52a83c0a30df6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21623f6498a3c668e76a49176cd717bfd254f915d61b06a1903a2aa2b7a1b7d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6989c8a8db65eced16393f5507a4c6e46e10c12ba91d51c359c28c81a2a22edd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54e16a3e07bd683a6263098a7bcfd5202840b35f19a4a7b038bfacc7213d4f08"
    sha256 cellar: :any_skip_relocation, sonoma:        "77d1423f43911501deb178049835075f0f3b7495b3713fb32e75e0e388eba705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "859475c04ea1cbb215d84de7b14e33e0455d9430bb6120dfaf682a8e49cb9921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6425d0c11f77f9c04bc3ad39a6fe1a1af2da6a45270319ce820e8cd4fdf438d3"
  end

  depends_on "python@3.14"

  resource "agate" do
    url "https://files.pythonhosted.org/packages/31/ff/3af96c18408ff5e4ef6d9028016ed3e73690ee67943a12a25812602e771a/agate-1.14.0.tar.gz"
    sha256 "426359123bebacd07a5c78397af1d8dc8f13c94e6cda34cc904227cd9e4bc222"
  end

  resource "agate-dbf" do
    url "https://files.pythonhosted.org/packages/ad/d8/abf6f39bd8c5767cc367472ea59f7d7cc4d5728388974a1b26a9472a971f/agate_dbf-0.2.4.tar.gz"
    sha256 "6554828b10048a76dbb5bc4eff8911e059ea2b47155b7a89351e382915ca16fc"
  end

  resource "agate-excel" do
    url "https://files.pythonhosted.org/packages/83/e5/b2d1bc555fd91145de5d11a7b31241076586713d222881c6d7eac9e4fda9/agate_excel-0.4.2.tar.gz"
    sha256 "eed1dc6239f0e96720d962dc1bdfb4496e19687332c827fd8b1e587a917ea202"
  end

  resource "agate-sql" do
    url "https://files.pythonhosted.org/packages/fe/fe/fc7662f1ec3c0917c377f74f143a479eb13c9ae5fe14d77ce28eb165564f/agate_sql-0.7.3.tar.gz"
    sha256 "4c588a28e80bc625c7d5f915e8f8dff4900140a8a6d8a350a098a2ba9adf9d33"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/6b/d52e42361e1aa00709585ecc30b3f9684b3ab62530771402248b1b1d6240/babel-2.17.0.tar.gz"
    sha256 "0c54cffb19f690cdcc52a3b50bcbf71e07a808d1c80d549f2459b9d2cf0afb9d"
  end

  resource "dbfread" do
    url "https://files.pythonhosted.org/packages/ad/ae/a5891681f5012724d062a4ca63ec2ff539c73d5804ba594e7e0e72099d3f/dbfread-2.0.7.tar.gz"
    sha256 "07c8a9af06ffad3f6f03e8fe91ad7d2733e31a26d2b72c4dd4cfbae07ee3b73d"
  end

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/d3/38/af70d7ab1ae9d4da450eeec1fa3918940a5fafb9055e934af8d6eb0c2313/et_xmlfile-2.0.0.tar.gz"
    sha256 "dab3f4764309081ce75662649be815c4c9081e88f0837825f90fd28317d4da54"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/c7/e5/40dbda2736893e3e53d25838e0f19a2b417dfc122b9989c91918db30b5d3/greenlet-3.3.0.tar.gz"
    sha256 "a82bb225a4e9e4d653dd2fb7b8b2d36e4fb25bc0165422a11e48b88e9e6f78fb"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "leather" do
    url "https://files.pythonhosted.org/packages/9e/09/849cf129d7eae1e42f873f2dbd60323267c738390b686a7384fb3fb289ad/leather-0.4.1.tar.gz"
    sha256 "67119c2aee93be821f077193bd8534e296c05b38bd174d9c5a80c4aa31d1a4d3"
  end

  resource "olefile" do
    url "https://files.pythonhosted.org/packages/69/1b/077b508e3e500e1629d366249c3ccb32f95e50258b231705c09e3c7a4366/olefile-0.47.zip"
    sha256 "599383381a0bf3dfbd932ca0ca6515acd174ed48870cbf7fee123d698c192c1c"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/3d/f9/88d94a75de065ea32619465d2f77b29a0469500e99012523b91cc4141cd1/openpyxl-3.1.5.tar.gz"
    sha256 "cf0e3cf56142039133628b5acffe8ef0c12bc902d2aadd3e0fe5878dc08d1050"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/87/c7/5e1547c44e31da50a460df93af11a535ace568ef89d7a811069ead340c4a/python-slugify-8.0.4.tar.gz"
    sha256 "59202371d1d05b54a9e7720c5e038f928f45daaffe41dd10822f3907b937c856"
  end

  resource "pytimeparse" do
    url "https://files.pythonhosted.org/packages/37/5d/231f5f33c81e09682708fb323f9e4041408d8223e2f0fb9742843328778f/pytimeparse-1.1.8.tar.gz"
    sha256 "e86136477be924d7e670646a98561957e8ca7308d44841e21f5ddea757556a0a"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/be/f9/5e4491e5ccf42f5d9cfc663741d261b3e6e1683ae7812114e7636409fcc6/sqlalchemy-2.0.45.tar.gz"
    sha256 "1632a4bda8d2d25703fdad6363058d882541bdaaee0e5e3ddfa0cd3229efce88"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "xlrd" do
    url "https://files.pythonhosted.org/packages/07/5a/377161c2d3538d1990d7af382c79f3b2372e880b65de21b01b1a2b78691e/xlrd-2.0.2.tar.gz"
    sha256 "08b5e25de58f21ce71dc7db3b3b8106c1fa776f3024c54e45b45b374e89234c9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "2,6", pipe_output("#{bin}/csvcut -c 1,3", "2,4,6,8", 0).chomp
  end
end
