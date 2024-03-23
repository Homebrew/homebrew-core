class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/12/30/9afa8353dca40bf1fd98f83deb36f52d12619b786ad028b8603da2819d0b/gallery_dl-1.26.9.tar.gz"
  sha256 "3e06dfa69c890a9805ba90509e0f0c50f8a16c39a2b780bec569d2cc2272bb99"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16e411b080581e596bd43d42b90aacfeebc39f680ac730859e8fb5a8822b65db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16e411b080581e596bd43d42b90aacfeebc39f680ac730859e8fb5a8822b65db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16e411b080581e596bd43d42b90aacfeebc39f680ac730859e8fb5a8822b65db"
    sha256 cellar: :any_skip_relocation, sonoma:         "16e411b080581e596bd43d42b90aacfeebc39f680ac730859e8fb5a8822b65db"
    sha256 cellar: :any_skip_relocation, ventura:        "16e411b080581e596bd43d42b90aacfeebc39f680ac730859e8fb5a8822b65db"
    sha256 cellar: :any_skip_relocation, monterey:       "16e411b080581e596bd43d42b90aacfeebc39f680ac730859e8fb5a8822b65db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3124618e13bea942aa1b7373b053f7b2bbede0320a8afd77a5ce52ec57111f1"
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
