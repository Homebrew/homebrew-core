class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/12/c0/b60ba0325ba97698a4a4615c8dd65d6300420797f58c2854da57d566f0a5/gallery_dl-1.25.7.tar.gz"
  sha256 "881bfb661fe4598fe4634d669e269b18d488a773cb8982ba20c20dc39d5f35d9"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fba0004c422bb8ddc53605014b4a09a15c93cb47ef249d56e8fef8aa4103315a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e32b90098172df17bce6dc6448422f5018c4c09d1b4116085061cd61a92d46dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69d48ece4f2ac45dd94baa27d9fe6ec80bbaca7ee7c390edd7f041f85070de5a"
    sha256 cellar: :any_skip_relocation, ventura:        "d0d69873bd17a56f85ba8cb3da4a760e1f16d5b009b2bd6b23180d6ce09d199d"
    sha256 cellar: :any_skip_relocation, monterey:       "f38bccc03bfc417ac1a1a41df54dc2c09ef34cab2a264f6c2d07f12debb36317"
    sha256 cellar: :any_skip_relocation, big_sur:        "6da27b337e5b6b7c6dfab645f07b19e0e6859ed524b7d8a22c2b4d32fe30b819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e86796b45d42d810d5705a8cf3d1f10e1b96ed0de81ceceb19386cd04a47f428"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
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
