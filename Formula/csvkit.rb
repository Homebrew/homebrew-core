class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/66/d8/206e4da52bcf9cc29dfa3a93837b14b37ba42f58ccbd22a42a3b3ae0381a/csvkit-1.0.4.tar.gz"
  sha256 "1353a383531bee191820edfb88418c13dfe1cdfa9dd3dc46f431c05cd2a260a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "89c69fb3bca0a55ea7c8ae84bdca28ddec9a3c9ff376b707d42686fe1d9c9e1e" => :catalina
    sha256 "6aa5bcb47f588ff16030bbb84db7ae9ac50377b5837cd19afb6dd7c6ebdadcb0" => :mojave
    sha256 "536f76460094339f456ef4546cb93f5c3f38dc0adb859e7730af80cc192e8215" => :high_sierra
    sha256 "548d3e5d15d6b2f1cbb2043d9d83b8fff650fcea8875eff94f018f79432b607f" => :sierra
  end

  depends_on "python"

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
    url "https://files.pythonhosted.org/packages/be/cc/9c981b249a455fa0c76338966325fc70b7265521bad641bf2932f77712f4/Babel-2.6.0.tar.gz"
    sha256 "8cba50f48c529ca3fa18cf81fa9403be176d374ac4d60738b839122dfaaa3d23"
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
    url "https://files.pythonhosted.org/packages/90/52/e20466b85000a181e1e144fd8305caf2cf475e2f9674e797b222f8105f5f/future-0.17.1.tar.gz"
    sha256 "67045236dcfd6816dc439556d009594abf643e5eb48992e36beac09c2ca659b8"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "jdcal" do
    url "https://files.pythonhosted.org/packages/3b/d5/181cab9a39dbe8060bd073acae2518e0378e66ff7509c4c6db0881d58e01/jdcal-1.4.tar.gz"
    sha256 "ea0a5067c5f0f50ad4c7bdc80abad3d976604f6fb026b0b3a17a9d84bb9046c9"
  end

  resource "leather" do
    url "https://files.pythonhosted.org/packages/a0/44/1acad8bfe958874c66825a4bdddbd277a549580b88c5daf3a4c128c521b0/leather-0.3.3.tar.gz"
    sha256 "076d1603b5281488285718ce1a5ce78cf1027fe1e76adf9c548caf83c519b988"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/5f/f8/a5d3a4ab669f99154f87ab531192dd84ac79aae62efab662bd2d82a72194/openpyxl-2.6.1.tar.gz"
    sha256 "9e4db4ee7aadd0ff7a814f7483b2d94e6b8d4f14dff780b023c5bdc94af54dd5"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/e3/b3/02385db13f1f25f04ad7895f35e9fe3960a4b9d53112775a6f7d63f264b6/parsedatetime-2.4.tar.gz"
    sha256 "3d817c58fb9570d1eec1dd46fa9448cd644eeed4fb612684b02dfda3a79cb84b"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/c3/67/89987e9f55b84badc33c0034b7554af988f6c5609182477677479e6ec2fd/python-slugify-3.0.0.tar.gz"
    sha256 "f5c5a43e76ea6820c892c30aba6c8bc1f848fbb8e1cba65ed1c8da7bb2b4c522"
  end

  resource "pytimeparse" do
    url "https://files.pythonhosted.org/packages/37/5d/231f5f33c81e09682708fb323f9e4041408d8223e2f0fb9742843328778f/pytimeparse-1.1.8.tar.gz"
    sha256 "e86136477be924d7e670646a98561957e8ca7308d44841e21f5ddea757556a0a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/af/be/6c59e30e208a5f28da85751b93ec7b97e4612268bb054d0dff396e758a90/pytz-2018.9.tar.gz"
    sha256 "d5f05e487007e29e03409f9398d074e158d920d36eb82eaf66fb1136b0c5374c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "SQLAlchemy" do
    url "https://files.pythonhosted.org/packages/85/29/d7a5687d0d21ea8133f2d4ef02dfb4d191afe7ebc8bd9f962d99bdf595e1/SQLAlchemy-1.3.1.tar.gz"
    sha256 "781fb7b9d194ed3fc596b8f0dd4623ff160e3e825dd8c15472376a438c19598b"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/f0/a2/40adaae7cbdd007fb12777e550b5ce344b56189921b9f70f37084c021ca4/text-unidecode-1.2.tar.gz"
    sha256 "5a1375bb2ba7968740508ae38d92e1f889a0832913cb1c447d5e2046061a396d"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/9b/d8/c1b658ed7ff6e63a745eda483d7d917eb63a79c59fcb422469b85ff47e94/Unidecode-1.0.23.tar.gz"
    sha256 "8b85354be8fd0c0e10adbf0675f6dc2310e56fda43fa8fe049123b6c475e52fb"
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
