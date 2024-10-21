class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/b6/29/51d7c3221669a4a63410f9be61178436109217d77a31b539f41ef6c1448e/csvkit-2.0.1.tar.gz"
  sha256 "aa9460266d5713ff312a414ed3edd86e0c3a31da9b2e2758cbe5643fe1146dd1"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "106ae5d779e9f30df86badd2dbc257aaf076bc0c6706aa9fb53e5be7b3c998c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27835141c5482861a319aa5583fb96d9c89a4ecdc3554457ef99c5725cff2aeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b06a73b1cb690646d3c890337306b9d1b4e994f1038f5c66396a7e63cabde31"
    sha256 cellar: :any_skip_relocation, sonoma:        "d98490b270c34cd98d3212bd4169fb05640f76fc01e0fe1dbe283faace1281ba"
    sha256 cellar: :any_skip_relocation, ventura:       "a5f0e7f34daca708aed4305b4372051de3bd85d5717633312cd4b79fd5be3aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac2f37b2461fceaf0dfee3517c45f3aa39d62c387ac28069c3095ba44bdf317f"
  end

  depends_on "python@3.13"

  resource "agate" do
    url "https://files.pythonhosted.org/packages/62/b5/7ea4dc82949dd40fb7277ce0fe9b57a44a1da28b1411327dc24ec2fffcff/agate-1.12.0.tar.gz"
    sha256 "7989841ac7de69e57389485c0b7cdab2e1a54c7480c629a76912bb7c331d991b"
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
    url "https://files.pythonhosted.org/packages/2a/74/f1bc80f23eeba13393b7222b11d95ca3af2c1e28edca18af487137eefed9/babel-2.16.0.tar.gz"
    sha256 "d1f3554ca26605fe173f3de0c65f750f5a42f924499bf134de6423582298e316"
  end

  resource "dbfread" do
    url "https://files.pythonhosted.org/packages/ad/ae/a5891681f5012724d062a4ca63ec2ff539c73d5804ba594e7e0e72099d3f/dbfread-2.0.7.tar.gz"
    sha256 "07c8a9af06ffad3f6f03e8fe91ad7d2733e31a26d2b72c4dd4cfbae07ee3b73d"
  end

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/3d/5d/0413a31d184a20c763ad741cc7852a659bf15094c24840c5bdd1754765cd/et_xmlfile-1.1.0.tar.gz"
    sha256 "8eb9e2bc2f8c97e37a2dc85a09ecdcdec9d8a396530a6d5a33b30b9a92da0c5c"
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
    url "https://files.pythonhosted.org/packages/36/48/4f190a83525f5cefefa44f6adc9e6386c4de5218d686c27eda92eb1f5424/sqlalchemy-2.0.35.tar.gz"
    sha256 "e11d7ea4d24f0a262bccf9a7cd6284c976c5369dac21db237cff59586045ab9f"
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
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    assert_equal "2,6", pipe_output("#{bin}/csvcut -c 1,3", "2,4,6,8", 0).chomp
  end
end
