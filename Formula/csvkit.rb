class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/b6/88/bdd8b8c77e8d8681b69d6689ca2a585d44eab2db23926a2c9e581a5ddd4b/csvkit-1.0.6.tar.gz"
  sha256 "c8f761b5605cc978a7515a3d6a9e7ceec49a08eeefd7ad78480dea5f8bf80d35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c1f559d761fdd6c4ba7aa8fa884d256774ffd1c68493c54457b4b3d589f8f476"
    sha256 cellar: :any_skip_relocation, big_sur:       "67a3a2f6a49ee30d64c1c231a153ac6149a06c356ac98bd5651f3aefa8487136"
    sha256 cellar: :any_skip_relocation, catalina:      "260b44371362ff818835f9f38c0beeaff83848a08e1097fbd20414131544f46a"
    sha256 cellar: :any_skip_relocation, mojave:        "cad9ebb425d3c77facf6cc5ea273cced3ceb1dedde4ff0886abb9440ce5e4e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04bbe89bbbef203b8871128d7be0f376c6258f77e07efe2116527b925df6d42c"
  end

  depends_on "python@3.9"

  resource "agate" do
    url "https://files.pythonhosted.org/packages/d4/1c/99fb34c81c68012c71e8d35a1f16a6b25952322e23c911c81327c8464be8/agate-1.6.1.tar.gz"
    sha256 "c93aaa500b439d71e4a5cf088d0006d2ce2c76f1950960c8843114e5f361dfd3"
  end

  resource "agate-dbf" do
    url "https://files.pythonhosted.org/packages/54/70/a32dfaa47cb7b4e4d70aff67d89c32984085b946442d26a9d9fca7d96d8b/agate-dbf-0.2.2.tar.gz"
    sha256 "589682b78c5c03f2dc8511e6e3edb659fb7336cd118e248896bb0b44c2f1917b"
  end

  resource "agate-excel" do
    url "https://files.pythonhosted.org/packages/38/38/b878fada40f3f7da274d9ceca1169d130ea43634e217b938e4d1a6e1510d/agate-excel-0.2.4.tar.gz"
    sha256 "1b8d76e505d9e3169e1bf208de9b9af63ce7726120c824b532e25cb6b70a1d20"
  end

  resource "agate-sql" do
    url "https://files.pythonhosted.org/packages/ad/29/d9883d5c1e54a78d9f2fb44a07749e6ebd4eae1bda919e4563b6bbd70ed0/agate-sql-0.5.7.tar.gz"
    sha256 "7622c1f243b5a9a5efddfe28c36eeeb30081e43e3eb72e8f3da22c2edaecf4d8"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/17/e6/ec9aa6ac3d00c383a5731cc97ed7c619d3996232c977bb8326bcbb6c687e/Babel-2.9.1.tar.gz"
    sha256 "bc0c176f9f6a994582230df350aa6e05ba2ebe4b3ac317eab29d9be5d2768da0"
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
    url "https://files.pythonhosted.org/packages/47/6d/be10df2b141fcb1020c9605f7758881b5af706fb09a05b737e8eb7540387/greenlet-1.1.0.tar.gz"
    sha256 "c87df8ae3f01ffb4483c796fe1b15232ce2b219f0b18126948616224d3f658ee"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "leather" do
    url "https://files.pythonhosted.org/packages/a0/44/1acad8bfe958874c66825a4bdddbd277a549580b88c5daf3a4c128c521b0/leather-0.3.3.tar.gz"
    sha256 "076d1603b5281488285718ce1a5ce78cf1027fe1e76adf9c548caf83c519b988"
  end

  resource "olefile" do
    url "https://files.pythonhosted.org/packages/34/81/e1ac43c6b45b4c5f8d9352396a14144bba52c8fec72a80f425f6a4d653ad/olefile-0.46.zip"
    sha256 "133b031eaf8fd2c9399b78b8bc5b8fcbe4c31e85295749bb17a87cba8f3c3964"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/f1/7d/fb475cd963bd9d244f95a90c98f518f5c834fefe749f25f9f479ca2d8a51/openpyxl-3.0.7.tar.gz"
    sha256 "6456a3b472e1ef0facb1129f3c6ef00713cebf62e736cd7a75bcc3247432f251"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/bc/a4/57893fbaf7cbf303a4f2307564cf83855a5f2cc34544656e7263125a0d1e/python-slugify-5.0.2.tar.gz"
    sha256 "f13383a0b9fcbe649a1892b9c8eb4f8eab1d6d84b84bb7a624317afa98159cab"
  end

  resource "pytimeparse" do
    url "https://files.pythonhosted.org/packages/37/5d/231f5f33c81e09682708fb323f9e4041408d8223e2f0fb9742843328778f/pytimeparse-1.1.8.tar.gz"
    sha256 "e86136477be924d7e670646a98561957e8ca7308d44841e21f5ddea757556a0a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "SQLAlchemy" do
    url "https://files.pythonhosted.org/packages/b6/6b/d802a9223430cc4f55d7993ede4cdafa683fb8a1260516c48bcd59729c74/SQLAlchemy-1.4.20.tar.gz"
    sha256 "38ee3a266afef2978e82824650457f70c5d74ec0cadec1b10fe5ed6f038eb5d0"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
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
