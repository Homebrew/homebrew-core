class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/9a/bf/59b035abead12d9498c96dc05b965ec77683d3c794305dec2648e23830cc/csvkit-2.2.0.tar.gz"
  sha256 "147318a8dbaec07c0bbb9291c14b78de5fa32ed3d4a5c2396e52a83c0a30df6b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2d7d0460a853ae6c31b1fe3eb54b4dc60f6bc47d9f625bb36d3d87ac62cb7d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb3eaa8d13cc298bd3f2c98d6809d2ff6ff7b5de9e66d5c1baac6b1e27b5b2ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd023d0a99815d167883bfef7f316fa230f4dffa2eecaaefa9adaf475c82b521"
    sha256 cellar: :any,                 arm64_linux:       "604436f12b954904039061480b79ecae98e993760844da7134c11022b34e34eb"
    sha256 cellar: :any,                 x86_64_linux:      "328979f494f8f170cd52fc7b613425bb6d7608f88515514eac92c089bfc204ae"
  end

  depends_on "python@3.15"

  resource "agate" do
    url "https://files.pythonhosted.org/packages/16/48/dc4d02dba00fbe62e966ed1a7d991e51654668ab343a2738bb816aa82256/agate-1.14.2.tar.gz"
    sha256 "7f29841c39d84b1de7fde762b8d792085371515324f3a01413b20f810398225b"
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
    url "https://files.pythonhosted.org/packages/7d/b2/51899539b6ceeeb420d40ed3cd4b7a40519404f9baf3d4ac99dc413a834b/babel-2.18.0.tar.gz"
    sha256 "b80b99a14bd085fcacfa15c9165f651fbb3406e66cc603abf11c5750937c992d"
  end

  resource "dbfread" do
    url "https://files.pythonhosted.org/packages/ad/ae/a5891681f5012724d062a4ca63ec2ff539c73d5804ba594e7e0e72099d3f/dbfread-2.0.7.tar.gz"
    sha256 "07c8a9af06ffad3f6f03e8fe91ad7d2733e31a26d2b72c4dd4cfbae07ee3b73d"
  end

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/d3/38/af70d7ab1ae9d4da450eeec1fa3918940a5fafb9055e934af8d6eb0c2313/et_xmlfile-2.0.0.tar.gz"
    sha256 "dab3f4764309081ce75662649be815c4c9081e88f0837825f90fd28317d4da54"
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
    url "https://files.pythonhosted.org/packages/bd/e8/26b1af09d728d604dc16427a39f53985b22a170dbd61addac3f48db73f03/python_slugify-9.1.3.tar.gz"
    sha256 "90e997f2e0987239ce95e12f700086eb18e1d1d3ee22624fbbdbd095afca42b6"
  end

  resource "pytimeparse" do
    url "https://files.pythonhosted.org/packages/25/54/09a581001791222c59d26f6317fc42955f011e79de2be933dfbf12bee3ed/pytimeparse-1.1.9.tar.gz"
    sha256 "1f1c0bedcfbe481b78f7cb11dba7d81039455af8ba014eafc6df060c9c0ab156"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/1f/44/311bac6b6ef81e4dfd0287d04900108b1f5c00c9761dd3c0a2b7b9d0f86b/sqlalchemy-2.1.4.tar.gz"
    sha256 "7bd7ad604487daa7eab8716471c29a7185f17b5287ce73bb7bc79fea050d8cfd"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
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
