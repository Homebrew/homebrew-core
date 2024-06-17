class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/71/3d/749ed206a8b7c5dcf401572c6cfb7cf0763f8495cc4cbbd24319cf2f65af/csvkit-2.0.0.tar.gz"
  sha256 "311f21787615a91656897e217c62ab26c8446d67309b61bd013e345b35816fdf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8be90609b763ed8335dade49147e742fdfd0a0f4e6ab4ec035ad3cc318fc7f66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "028ea2623a41a7c3518ae7dee60aee665fc1705e61292076ef0c7159ec5b9adc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "617662e9e164a1eed8e70484fe4b4f46c1213873c69cdcdb3cdfd460fa937e1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e86f79566125beba09422fd8da90947b531507fb51d0aa8b7865f16b30cdcd45"
    sha256 cellar: :any_skip_relocation, ventura:        "9d7089759d0a99a588c1ce903718be0395e2266e9cf9ad34482b83ddfdcbb64f"
    sha256 cellar: :any_skip_relocation, monterey:       "f67b98941785465a1643d4b59db2d7349450ee989aec941682a9313068c83267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c84f1cddc535043197187f1abb0256597233ec525fe841676af6dd568a09a0bf"
  end

  depends_on "python@3.12"

  resource "agate" do
    url "https://files.pythonhosted.org/packages/07/22/d56bcab24af5c34d8c7e8122cb94507aa58ad5e1d54e0da584c323a58c26/agate-1.10.2.tar.gz"
    sha256 "336b1e3e98a1127afbac6e26cc06f369b43ab00b7c63079ab06f0971dc389f68"
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
    url "https://files.pythonhosted.org/packages/e2/80/cfbe44a9085d112e983282ee7ca4c00429bc4d1ce86ee5f4e60259ddff7f/Babel-2.14.0.tar.gz"
    sha256 "6919867db036398ba21eb5c7a0f6b28ab8cbc3ae7a73a44ebe34ae74a4e7d363"
  end

  resource "dbfread" do
    url "https://files.pythonhosted.org/packages/ad/ae/a5891681f5012724d062a4ca63ec2ff539c73d5804ba594e7e0e72099d3f/dbfread-2.0.7.tar.gz"
    sha256 "07c8a9af06ffad3f6f03e8fe91ad7d2733e31a26d2b72c4dd4cfbae07ee3b73d"
  end

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/3d/5d/0413a31d184a20c763ad741cc7852a659bf15094c24840c5bdd1754765cd/et_xmlfile-1.1.0.tar.gz"
    sha256 "8eb9e2bc2f8c97e37a2dc85a09ecdcdec9d8a396530a6d5a33b30b9a92da0c5c"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/17/14/3bddb1298b9a6786539ac609ba4b7c9c0842e12aa73aaa4d8d73ec8f8185/greenlet-3.0.3.tar.gz"
    sha256 "43374442353259554ce33599da8b692d5aa96f8976d567d4badf263371fbe491"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
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
    url "https://files.pythonhosted.org/packages/42/e8/af028681d493814ca9c2ff8106fc62a4a32e4e0ae14602c2a98fc7b741c8/openpyxl-3.1.2.tar.gz"
    sha256 "a6f5977418eff3b2d5500d54d9db50c8277a368436f4e4f8ddb1be3422870184"
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/99/04/59971bfc2f192e3b52376ca8d1e134c78d04bc044ef7e04cf10c42d2ce17/SQLAlchemy-2.0.29.tar.gz"
    sha256 "bd9566b8e58cabd700bc367b60e90d9349cd16f0984973f98a9a09f9c64e86f0"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
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
