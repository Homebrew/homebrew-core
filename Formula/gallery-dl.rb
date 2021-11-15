class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/bd/15/2da44a9d797c6394af00a5d06b5007e45c01057ee23a3159d417fa82d853/gallery_dl-1.19.2.tar.gz"
  sha256 "7fec9ac69582dbd9922666e6ece3142ae52dc9679a2c4a613f6ee94ad09e5f68"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40e40f33d68e11a37ed91bf67141fe93872a98898285352edcaf1e1f654184be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40e40f33d68e11a37ed91bf67141fe93872a98898285352edcaf1e1f654184be"
    sha256 cellar: :any_skip_relocation, monterey:       "04fe21823a7b19cb61bd999ae9bdbf50d1b37d6079063c560f483e9c3cdc4cca"
    sha256 cellar: :any_skip_relocation, big_sur:        "04fe21823a7b19cb61bd999ae9bdbf50d1b37d6079063c560f483e9c3cdc4cca"
    sha256 cellar: :any_skip_relocation, catalina:       "04fe21823a7b19cb61bd999ae9bdbf50d1b37d6079063c560f483e9c3cdc4cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea344e039c2b476687fd008107a629b039ac1fdcb67c9656c7245ed003a6cb4f"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
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
