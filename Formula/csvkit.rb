class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/53/de/a8ee2fb47af463251fd39e0dc2b7356ceb58fd0f5867f7f6d0f7cc6e8a0d/csvkit-1.0.2.tar.gz"
  sha256 "5a897f87c920dec3e7debc31102dfe774a8d704641bfafa98e04729bd4d26e17"

  bottle do
    cellar :any_skip_relocation
    sha256 "76107c7ba4afd9cb68e8d8ec364374932d7130456fd6e7b4f7f55958c80c17cb" => :high_sierra
    sha256 "e915fdcd3ab965e464fc0a4216e7d1bd398ed659d7ef03c334168ea9c489826e" => :sierra
    sha256 "cbfeef9899fd671d862f06e55974639bfeb60adbef9e44fd23bee25ad21c887a" => :el_capitan
  end

  depends_on :python3

  resource "agate" do
    url "https://files.pythonhosted.org/packages/72/37/48192f2cb18c7ebe413f7410783b64a6236d20a4461f5c36f5efcb793f89/agate-1.6.0.tar.gz"
    sha256 "1547eb66a4caaea08cc247077e5b3740629be6724a047c94be0ecbbfa52ceb0a"
  end

  resource "agate-dbf" do
    url "https://files.pythonhosted.org/packages/61/81/17a635599352eab163958905a70261f9eb1d7c4b54036d1c2115adf88162/agate-dbf-0.2.0.tar.gz"
    sha256 "0666c1ad06cd4b2860351cebbd88bd4b05b2d1abd41b25cf91f8f6715035735e"
  end

  resource "agate-excel" do
    url "https://files.pythonhosted.org/packages/ab/62/c74895d6f715624646a2e2e9bb022a84c9c7a37577bf3bc98907e47c5e5a/agate-excel-0.2.1.tar.gz"
    sha256 "c7621051307a4650b95309a2e13f5774d08719421c9d965b461629a002d048b4"
  end

  resource "agate-sql" do
    url "https://files.pythonhosted.org/packages/25/38/fc14fb76e63b3e133c5a6cca798af0ea18b90a9d6068dfd5676dbb5bec1d/agate-sql-0.5.2.tar.gz"
    sha256 "2458cec76c9b4effccc604d286d6284d315d2cd9dd1e9943067a596728e68e62"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/5a/22/63f1dbb8514bb7e0d0c8a85cc9b14506599a075e231985f98afd70430e1f/Babel-2.5.1.tar.gz"
    sha256 "6007daf714d0cd5524bbe436e2d42b3c20e68da66289559341e48d2cd6d25811"
  end

  resource "dbfread" do
    url "https://files.pythonhosted.org/packages/ad/ae/a5891681f5012724d062a4ca63ec2ff539c73d5804ba594e7e0e72099d3f/dbfread-2.0.7.tar.gz"
    sha256 "07c8a9af06ffad3f6f03e8fe91ad7d2733e31a26d2b72c4dd4cfbae07ee3b73d"
  end

  resource "et_xmlfile" do
    url "https://files.pythonhosted.org/packages/22/28/a99c42aea746e18382ad9fb36f64c1c1f04216f41797f2f0fa567da11388/et_xmlfile-1.0.1.tar.gz"
    sha256 "614d9722d572f6246302c4491846d2c393c199cfa4edc9af593437691683335b"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "jdcal" do
    url "https://files.pythonhosted.org/packages/9b/fa/40beb2aa43a13f740dd5be367a10a03270043787833409c61b79e69f1dfd/jdcal-1.3.tar.gz"
    sha256 "b760160f8dc8cc51d17875c6b663fafe64be699e10ce34b6a95184b5aa0fdc9e"
  end

  resource "leather" do
    url "https://files.pythonhosted.org/packages/a0/44/1acad8bfe958874c66825a4bdddbd277a549580b88c5daf3a4c128c521b0/leather-0.3.3.tar.gz"
    sha256 "076d1603b5281488285718ce1a5ce78cf1027fe1e76adf9c548caf83c519b988"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/8c/75/c4e557207c7ff3d217d002d4fee32b4e5dbfc5498e2a2c9ce6b5424c5e37/openpyxl-2.4.9.tar.gz"
    sha256 "95e007f4d121f4fd73f39a6d74a883c75e9fa9d96de91d43c1641c103c3a9b18"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/e3/b3/02385db13f1f25f04ad7895f35e9fe3960a4b9d53112775a6f7d63f264b6/parsedatetime-2.4.tar.gz"
    sha256 "3d817c58fb9570d1eec1dd46fa9448cd644eeed4fb612684b02dfda3a79cb84b"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/9f/b0/2723356c20fb01b0e09f6ee03c0c629f4e30811e7d92ebd15453d648e5f0/python-slugify-1.2.4.tar.gz"
    sha256 "57a385df7a1c6dbd15f7666eaff0ff29d3f60363b228b1197c5308ed3ba5f824"
  end

  resource "pytimeparse" do
    url "https://files.pythonhosted.org/packages/a0/04/3bed21467ade80579ce4dd867055e6150444543de013fca55ce8fb0505c9/pytimeparse-1.1.7.tar.gz"
    sha256 "51b641bcd435e0cb6b9701ed79cf7ee97fa6bf2dbb5d41baa16e5486e5d9b17a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/60/88/d3152c234da4b2a1f7a989f89609ea488225eaea015bc16fbde2b3fdfefa/pytz-2017.3.zip"
    sha256 "fae4cffc040921b8a2d60c6cf0b5d662c1190fe54d718271db4eb17d44a185b7"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "SQLAlchemy" do
    url "https://files.pythonhosted.org/packages/c2/f6/11fcc1ce19a7cb81b1c9377f4e27ce3813265611922e355905e57c44d164/SQLAlchemy-1.1.15.tar.gz"
    sha256 "8b79a5ed91cdcb5abe97b0045664c55c140aec09e5dd5c01303e23de5fe7a95a"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/0e/26/6a4295c494e381d56bba986893382b5dd5e82e2643fc72e4e49b6c99ce15/Unidecode-0.04.21.tar.gz"
    sha256 "280a6ab88e1f2eb5af79edff450021a0d3f0448952847cd79677e55e58bad051"
  end

  resource "xlrd" do
    url "https://files.pythonhosted.org/packages/86/cf/bb010f16cefa8f26ac9329ca033134bcabc7a27f5c3d8de961bacc0f80b3/xlrd-1.1.0.tar.gz"
    sha256 "8a21885513e6d915fe33a8ee5fdfa675433b61405ba13e2a69e62ee36828d7e2"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    assert_equal "2,6", pipe_output("#{bin}/csvcut -c 1,3", "2,4,6,8", 0).chomp
  end
end
