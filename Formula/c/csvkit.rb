class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/d7/b3/2ddfc514620a7c6bc22f6c0f04b27fe88d8111d96977920ff230e061fa69/csvkit-1.2.0.tar.gz"
  sha256 "f927373b97b74d0e17957857a5d51d442127475e42a51e621572b1ba31a018d9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca3f6ebab260acafdbf2c2081be989471f88815ad52a5c61fac39ea5d30cda87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69af61284b63b7977895f87244293d1140c40dafd77efde72d73400c100b88d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f054e1eb9a05c6e8f52fb99612edf7019cdc574288a459f53c707c208c9da5"
    sha256 cellar: :any_skip_relocation, sonoma:         "774560a24381b925a20b87db0bae6a93a3b42fc5875f0bf25c7c542afd23d228"
    sha256 cellar: :any_skip_relocation, ventura:        "1a332c39febc3acbeff25b8fee0ce977cd339db802f5e40c73a0f853b6b49cb9"
    sha256 cellar: :any_skip_relocation, monterey:       "e0dca789566636e6a64a93ea24824367befb65af05fd0b05ba9d8bb0c6ce17cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa73bc4dcdcf903367de6c5ace90c8873d382f3928971f19ee02ec33c8619ecb"
  end

  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "six"

  resource "agate" do
    url "https://files.pythonhosted.org/packages/07/12/c95569f05a85164e14ba13f974dca942a75b727bedab3925f2a29e175589/agate-1.7.1.tar.gz"
    sha256 "eadf46d980168b8922d5d396d6258eecd5e7dbef7e6f0c0b71e968545ea96389"
  end

  resource "agate-dbf" do
    url "https://files.pythonhosted.org/packages/54/70/a32dfaa47cb7b4e4d70aff67d89c32984085b946442d26a9d9fca7d96d8b/agate-dbf-0.2.2.tar.gz"
    sha256 "589682b78c5c03f2dc8511e6e3edb659fb7336cd118e248896bb0b44c2f1917b"
  end

  resource "agate-excel" do
    url "https://files.pythonhosted.org/packages/7c/85/f74ba95d9b4d53ffab0e17a1133d5e5f8c1910f4b48f9f7c116f3bf0c1c8/agate-excel-0.2.5.tar.gz"
    sha256 "62315708433108772f7f610ca769996b468a4ead380076dbaf6ffe262831b153"
  end

  resource "agate-sql" do
    url "https://files.pythonhosted.org/packages/5e/e6/0c5ec2dcc5786145377cf1d4b870f12950cd39b24c9760d36eb0cf1e32b7/agate-sql-0.6.0.tar.gz"
    sha256 "1582141e13c6c5af300936db13d1e0a8128ebd9c595834f60d284d6d3ef51bee"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/d5/7d/08e7b8b1ab446121ace3de332f144be41a52049a23303375a0126d515cb7/Babel-2.13.0.tar.gz"
    sha256 "04c3e2d28d2b7681644508f836be388ae49e0cfe91465095340395b60d00f210"
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
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "leather" do
    url "https://files.pythonhosted.org/packages/73/c5/5bc5a19a62147ee8ff2de7b416ee6534b5bd79f22c790d0365ebef223f34/leather-0.3.4.tar.gz"
    sha256 "b43e21c8fa46b2679de8449f4d953c06418666dc058ce41055ee8a8d3bb40918"
  end

  resource "olefile" do
    url "https://files.pythonhosted.org/packages/34/81/e1ac43c6b45b4c5f8d9352396a14144bba52c8fec72a80f425f6a4d653ad/olefile-0.46.zip"
    sha256 "133b031eaf8fd2c9399b78b8bc5b8fcbe4c31e85295749bb17a87cba8f3c3964"
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
    url "https://files.pythonhosted.org/packages/de/63/0f60208d0d3dde1a87d30a82906fa9b00e902b57f1ae9565d780de4b41d1/python-slugify-8.0.1.tar.gz"
    sha256 "ce0d46ddb668b3be82f4ed5e503dbc33dd815d83e2eb6824211310d3fb172a27"
  end

  resource "pytimeparse" do
    url "https://files.pythonhosted.org/packages/37/5d/231f5f33c81e09682708fb323f9e4041408d8223e2f0fb9742843328778f/pytimeparse-1.1.8.tar.gz"
    sha256 "e86136477be924d7e670646a98561957e8ca7308d44841e21f5ddea757556a0a"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/fa/fd/f835dcfb49eabf12e8ea7c7779d364f7730a47912ae64ff38cd4a316ab77/SQLAlchemy-2.0.21.tar.gz"
    sha256 "05b971ab1ac2994a14c56b35eaaa91f86ba080e9ad481b20d99d77f381bb6258"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/1f/7a/8b94bb016069caa12fc9f587b28080ac33b4fbb8ca369b98bc0a4828543e/typing_extensions-4.8.0.tar.gz"
    sha256 "df8e4339e9cb77357558cbdbceca33c303714cf861d1eef15e1070055ae8b7ef"
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
