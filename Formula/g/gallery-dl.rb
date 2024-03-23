class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/12/30/9afa8353dca40bf1fd98f83deb36f52d12619b786ad028b8603da2819d0b/gallery_dl-1.26.9.tar.gz"
  sha256 "3e06dfa69c890a9805ba90509e0f0c50f8a16c39a2b780bec569d2cc2272bb99"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "304afdfe138dab87a10f42cbc117e63804f5d3bdcaa22ae0f78f1dd5dd94c1eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af4b34feb71c34f9b4b234d5479ac9437b544b25ca8edc20d3e30af68c605f02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab4b449629a6f964f025af150d7b1f3dbb29c0fabc311e71874147182c70aa14"
    sha256 cellar: :any_skip_relocation, sonoma:         "27280c428b64b98cdafaac807be11210049cf3031a7818e5fb9314093ebc369f"
    sha256 cellar: :any_skip_relocation, ventura:        "c5deed672299d2bc0612f13f2f6ecf964f00663af2605ef4bbf057ece60d2ae6"
    sha256 cellar: :any_skip_relocation, monterey:       "fad773afb4ab7e36e28ee180ad0aaf2d39f8f2fdb265d44187de0e02be790e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dca970a658c6e8d1469e14cd44e8b6ce83f49d5349ab6063a3c046faa38a6201"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
