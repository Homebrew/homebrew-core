class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/80/e2/b6317dc421111a8158ce186095208127b4d53d823b40d9268cffbf06b73b/csvkit-2.1.0.tar.gz"
  sha256 "b91e8f5a485888c3c515b15cc2525ce4be5cfcd4f4766ead83113e787b5fd536"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38e538889d230e83686382e09b013d4f15792e1209c8191d38d8c1f497a22aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb219535aa5e1bdbece458a3e7aac6b43a2f42cea46dea519c9897ebd315aa9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "993b70d9af69862534b8f3fd6c1746d2eca303d35a671f7ca9af48317e5f9d30"
    sha256 cellar: :any_skip_relocation, sonoma:        "39e0b38a1826e4991f03acb2836452c783a57089d81609b666cc999c3faa0af4"
    sha256 cellar: :any_skip_relocation, ventura:       "a656b465e6057aa27443398d98284b91c2975546014f3af373b29ead39c3d13c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0381b3f897796ddf740e114a0227d07d485a0adceae1b7293e969bba2f5b5a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1e5f5f59d037761c45c7960dd7834988295aed1150e74ee91b2042e672741c"
  end

  depends_on "python@3.13"

  resource "agate" do
    url "https://files.pythonhosted.org/packages/38/a5/3773a25b4b4867efbe69dd34f374020e1c66415ac96afc572ac7aa47d90c/agate-1.13.0.tar.gz"
    sha256 "24bc3d3cbd165aa3ab0ef9e798dd4c53ad703012d450fe89b9c26b239505c445"
  end

  resource "agate-dbf" do
    url "https://files.pythonhosted.org/packages/e7/b1/4de32f53777a304f63fb781b0ec4520af4e011ba477d7214672b3c92d2da/agate-dbf-0.2.3.tar.gz"
    sha256 "98a2b53757136cc74dc297e59e2101d34f6d48f41f74156bb6c0de26bba2aa3f"
  end

  resource "agate-excel" do
    url "https://files.pythonhosted.org/packages/07/93/350f95d3cca0e1f43d55d48879bc33dd54b8c5619ebdac7d2adf42a3cc92/agate-excel-0.4.1.tar.gz"
    sha256 "28426618c90747111e6d566e983d838f1e2fae641ea6970d7acb0e9d4b384091"
  end

  resource "agate-sql" do
    url "https://files.pythonhosted.org/packages/11/9e/004234db38834e805cf8df6dff5d5d819a9909b247ef57d4c23208b04332/agate-sql-0.7.2.tar.gz"
    sha256 "9b1b30284a573fd416759437273dcc5c81022bdf2facb24b4aa029a62afd53b0"
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
    url "https://files.pythonhosted.org/packages/2f/ff/df5fede753cc10f6a5be0931204ea30c35fa2f2ea7a35b25bdaf4fe40e46/greenlet-3.1.1.tar.gz"
    sha256 "4ce3ac6cdb6adf7946475d7ef31777c26d94bccc377e070a7986bd2d5c515467"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "leather" do
    url "https://files.pythonhosted.org/packages/ed/6e/48a05e2f7f62a616d675cfee182643f2dd8023bf7429aa326f4bebd629c8/leather-0.4.0.tar.gz"
    sha256 "f964bec2086f3153a6c16e707f20cb718f811f57af116075f4c0f4805c608b95"
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
    url "https://files.pythonhosted.org/packages/e4/08/9a90962ea72acd532bda71249a626344d855c4032603924b1b547694b837/sqlalchemy-2.0.38.tar.gz"
    sha256 "e5a4d82bdb4bf1ac1285a68eab02d253ab73355d9f0fe725a97e1e0fa689decb"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "xlrd" do
    url "https://files.pythonhosted.org/packages/a6/b3/19a2540d21dea5f908304375bd43f5ed7a4c28a370dc9122c565423e6b44/xlrd-2.0.1.tar.gz"
    sha256 "f72f148f54442c6b056bf931dbc34f986fd0c3b0b6b5a58d013c9aef274d0c88"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "2,6", pipe_output("#{bin}/csvcut -c 1,3", "2,4,6,8", 0).chomp
  end
end
