class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/18/4d/7e32f82523b496e2a9238e927b7d70bd38e63d6a8c580ec6c340e5d110f7/gallery_dl-1.19.0.tar.gz"
  sha256 "ceffaa5022d76132165ca9004c1e57d7400b56c9ab3866e3bd139e2ffe38cb72"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/mikf/gallery-dl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "513b2f6957f446837f4848bf350dcf49dbca2064ff6f0f96da7aed4355821d06"
    sha256 cellar: :any_skip_relocation, big_sur:       "57afdd3a6f83e754e3611f3535f23dfbfc433f5c890d2990ecb6d476a06389f8"
    sha256 cellar: :any_skip_relocation, catalina:      "57afdd3a6f83e754e3611f3535f23dfbfc433f5c890d2990ecb6d476a06389f8"
    sha256 cellar: :any_skip_relocation, mojave:        "57afdd3a6f83e754e3611f3535f23dfbfc433f5c890d2990ecb6d476a06389f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e77a88f12070dffe24577f2ae853c879c30c6b6c5d35d0b29152eac5daee620e"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/eb/7f/a6c278746ddbd7094b019b08d1b2187101b1f596f35f81dc27f57d8fcf7c/charset-normalizer-2.0.6.tar.gz"
    sha256 "5ec46d183433dcbd0ab716f2d7f29d8dee50505b3fdb40c6b985c7c4f5a3591f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
