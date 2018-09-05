class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/01/69/476d4e74d84bcc5196f6b6a87b419363e163bc8c31d0660166f9e447bd97/csvkit-1.0.3.tar.gz"
  sha256 "a6c859c1321d4697dc41252877249091681297f093e08d9c1e1828a6d52c260c"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a19e9c93534cc8df3ffa41c588a97888a18982e8d7918a64fab85c999b44411" => :mojave
    sha256 "538553279108f93aa58cfcfcef0b9e1ea5b348afa333d46e0b47de3113b47522" => :high_sierra
    sha256 "e5df4e6c87d70f4bef969071019603b2985c62c0e5f3ea454639e917ac678065" => :sierra
    sha256 "bbffc0f3b3d118135dd52b7830687fb369d2f8d79f556ae8520e6e677a1faf4c" => :el_capitan
  end

  depends_on "python"

  resource "agate" do
    url "https://files.pythonhosted.org/packages/d4/1c/99fb34c81c68012c71e8d35a1f16a6b25952322e23c911c81327c8464be8/agate-1.6.1.tar.gz"
    sha256 "c93aaa500b439d71e4a5cf088d0006d2ce2c76f1950960c8843114e5f361dfd3"
  end

  resource "agate-dbf" do
    url "https://files.pythonhosted.org/packages/61/81/17a635599352eab163958905a70261f9eb1d7c4b54036d1c2115adf88162/agate-dbf-0.2.0.tar.gz"
    sha256 "0666c1ad06cd4b2860351cebbd88bd4b05b2d1abd41b25cf91f8f6715035735e"
  end

  resource "agate-excel" do
    url "https://files.pythonhosted.org/packages/02/c0/b82c6f830946203ec16d83eb8a6b250309ba8dcec14640b94eb69d88d30c/agate-excel-0.2.2.tar.gz"
    sha256 "8923f71ee2b5b7b21e52fb314a769b28fb902f647534f5cbbb41991d8710f4c7"
  end

  resource "agate-sql" do
    url "https://files.pythonhosted.org/packages/c7/0c/8ff3f82bf7ca84b2f12362553029830a582a2065499259e9498f08964c99/agate-sql-0.5.3.tar.gz"
    sha256 "877b7b85adb5f0325455bba8d50a1623fa32af33680b554feca7c756a15ad9b4"
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
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
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
    url "https://files.pythonhosted.org/packages/f6/13/3c1263b852377738eaa60f99602fb58cc8ad2fd1badb0b724b0d5b532727/openpyxl-2.5.4.tar.gz"
    sha256 "9239b74faf175dc4276a5fc277655fc53c2f704ded39e680d35e6a39e1913f69"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/e3/b3/02385db13f1f25f04ad7895f35e9fe3960a4b9d53112775a6f7d63f264b6/parsedatetime-2.4.tar.gz"
    sha256 "3d817c58fb9570d1eec1dd46fa9448cd644eeed4fb612684b02dfda3a79cb84b"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/70/c1/98bfb2c981787dcec4613c5da2c17d6f54613935b0e3a877e87a9fa974e4/python-slugify-1.2.5.tar.gz"
    sha256 "5dbb360b882b2dabe0471a1a92f604504d83c2a73c71f2098d004ab62e695534"
  end

  resource "pytimeparse" do
    url "https://files.pythonhosted.org/packages/37/5d/231f5f33c81e09682708fb323f9e4041408d8223e2f0fb9742843328778f/pytimeparse-1.1.8.tar.gz"
    sha256 "e86136477be924d7e670646a98561957e8ca7308d44841e21f5ddea757556a0a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ca/a9/62f96decb1e309d6300ebe7eee9acfd7bccaeedd693794437005b9067b44/pytz-2018.5.tar.gz"
    sha256 "ffb9ef1de172603304d9d2819af6f5ece76f2e85ec10692a524dd876e72bf277"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "SQLAlchemy" do
    url "https://files.pythonhosted.org/packages/28/99/ad4dd8240ff8a98c8786fef6d2b392fb2309b0c2bcf23fdfbf3a4cb1a499/SQLAlchemy-1.2.9.tar.gz"
    sha256 "e21e5561a85dcdf16b8520ae4daec7401c5c24558e0ce004f9b60be75c4b6957"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/9d/36/49d0ee152b6a1631f03a541532c6201942430060aa97fe011cf01a2cce64/Unidecode-1.0.22.tar.gz"
    sha256 "8c33dd588e0c9bc22a76eaa0c715a5434851f726131bd44a6c26471746efabf5"
  end

  resource "xlrd" do
    url "https://files.pythonhosted.org/packages/86/cf/bb010f16cefa8f26ac9329ca033134bcabc7a27f5c3d8de961bacc0f80b3/xlrd-1.1.0.tar.gz"
    sha256 "8a21885513e6d915fe33a8ee5fdfa675433b61405ba13e2a69e62ee36828d7e2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "2,6", pipe_output("#{bin}/csvcut -c 1,3", "2,4,6,8", 0).chomp
  end
end
