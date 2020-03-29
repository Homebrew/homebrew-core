class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/95/c9/8dd118c0ea0114125a8bf50d552626b95f6478bcf29a252296e93d778855/csvkit-1.0.5.tar.gz"
  sha256 "7bd390f4d300e45dc9ed67a32af762a916bae7d9a85087a10fd4f64ce65fd5b9"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1bb059e0420e7f4e117ad9bb0ad9ec2e281547c87ce3dec197dbcbcc2fbb3223" => :catalina
    sha256 "39eb13816f8ea1ff6e91d759450a1cb56edc558cdc997776eb60a1fbfeaf4881" => :mojave
    sha256 "2d7e167505bd1635d0fa97f525683c5a938cb6ebf7351299260822a4560cf513" => :high_sierra
  end

  depends_on "python@3.8"

  resource "agate" do
    url "https://files.pythonhosted.org/packages/d4/1c/99fb34c81c68012c71e8d35a1f16a6b25952322e23c911c81327c8464be8/agate-1.6.1.tar.gz"
    sha256 "c93aaa500b439d71e4a5cf088d0006d2ce2c76f1950960c8843114e5f361dfd3"
  end

  resource "agate-dbf" do
    url "https://files.pythonhosted.org/packages/cb/05/8bd93fd8f47354e5a31b1ba5876a9498a59fa32166b2e3315da43774adb8/agate-dbf-0.2.1.tar.gz"
    sha256 "00c93c498ec9a04cc587bf63dd7340e67e2541f0df4c9a7259d7cb3dd4ce372f"
  end

  resource "agate-excel" do
    url "https://files.pythonhosted.org/packages/a9/cd/ba7ce638900a91f00e6ebaa72c46fc90bfc13cb595071cee82c96057d5d6/agate-excel-0.2.3.tar.gz"
    sha256 "8f255ef2c87c436b7132049e1dd86c8e08bf82d8c773aea86f3069b461a17d52"
  end

  resource "agate-sql" do
    url "https://files.pythonhosted.org/packages/4a/fb/796c6e7b625fde74274786da69f08aca5c5eefb891db77344f95ad7b75db/agate-sql-0.5.4.tar.gz"
    sha256 "9277490ba8b8e7c747a9ae3671f52fe486784b48d4a14e78ca197fb0e36f281b"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/34/18/8706cfa5b2c73f5a549fdc0ef2e24db71812a2685959cff31cbdfc010136/Babel-2.8.0.tar.gz"
    sha256 "1aac2ae2d0d8ea368fa90906567f5c08463d98ade155c0c4bfedd6a0f7160e38"
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
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "jdcal" do
    url "https://files.pythonhosted.org/packages/7b/b0/fa20fce23e9c3b55b640e629cb5edf32a85e6af3cf7af599940eb0c753fe/jdcal-1.4.1.tar.gz"
    sha256 "472872e096eb8df219c23f2689fc336668bdb43d194094b5cc1707e1640acfc8"
  end

  resource "leather" do
    url "https://files.pythonhosted.org/packages/a0/44/1acad8bfe958874c66825a4bdddbd277a549580b88c5daf3a4c128c521b0/leather-0.3.3.tar.gz"
    sha256 "076d1603b5281488285718ce1a5ce78cf1027fe1e76adf9c548caf83c519b988"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/95/8c/83563c60489954e5b80f9e2596b93a68e1ac4e4a730deb1aae632066d704/openpyxl-3.0.3.tar.gz"
    sha256 "547a9fc6aafcf44abe358b89ed4438d077e9d92e4f182c87e2dc294186dc4b64"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/5f/19/43357ced106dd1ab6bceb1decb866e8619172fc271991a54eb2f680a2e9b/parsedatetime-2.5.tar.gz"
    sha256 "d2e9ddb1e463de871d32088a3f3cea3dc8282b1b2800e081bd0ef86900451667"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/92/5f/7b84a0bba8a0fdd50c046f8b57dcf179dc16237ad33446079b7c484de04c/python-slugify-4.0.0.tar.gz"
    sha256 "a8fc3433821140e8f409a9831d13ae5deccd0b033d4744d94b31fea141bdd84c"
  end

  resource "pytimeparse" do
    url "https://files.pythonhosted.org/packages/37/5d/231f5f33c81e09682708fb323f9e4041408d8223e2f0fb9742843328778f/pytimeparse-1.1.8.tar.gz"
    sha256 "e86136477be924d7e670646a98561957e8ca7308d44841e21f5ddea757556a0a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/82/c3/534ddba230bd4fbbd3b7a3d35f3341d014cca213f369a9940925e7e5f691/pytz-2019.3.tar.gz"
    sha256 "b02c06db6cf09c12dd25137e563b31700d3b80fcc4ad23abb7a315f2789819be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "SQLAlchemy" do
    url "https://files.pythonhosted.org/packages/af/47/35edeb0f86c0b44934c05d961c893e223ef27e79e1f53b5e6f14820ff553/SQLAlchemy-1.3.13.tar.gz"
    sha256 "64a7b71846db6423807e96820993fa12a03b89127d278290ca25c0b11ed7b4fb"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/b1/d6/7e2a98e98c43cf11406de6097e2656d31559f788e9210326ce6544bd7d40/Unidecode-1.1.1.tar.gz"
    sha256 "2b6aab710c2a1647e928e36d69c21e76b453cd455f4e2621000e54b2a9b8cce8"
  end

  resource "xlrd" do
    url "https://files.pythonhosted.org/packages/aa/05/ec9d4fcbbb74bbf4da9f622b3b61aec541e4eccf31d3c60c5422ec027ce2/xlrd-1.2.0.tar.gz"
    sha256 "546eb36cee8db40c3eaa46c351e67ffee6eeb5fa2650b71bc4c758a29a1b29b2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "2,6", pipe_output("#{bin}/csvcut -c 1,3", "2,4,6,8", 0).chomp
  end
end
