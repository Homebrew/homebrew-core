class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/03/52/c789b2166196133ec9522f48d3502f7abafa62f441b66aae77f4a51a2e17/gallery_dl-1.19.3.tar.gz"
  sha256 "db3973a17f1074e4f4cb99b635b94c1926bdd549263e1df909498f3c6aa93484"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e51d932b4258d0bcb53f6a65375126f06fead5c41118301222be0fe5de4afbc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e51d932b4258d0bcb53f6a65375126f06fead5c41118301222be0fe5de4afbc0"
    sha256 cellar: :any_skip_relocation, monterey:       "9d92bd28618434e28fbea81c253b03468075f8dc3af238e3ed157d59fefdae8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d92bd28618434e28fbea81c253b03468075f8dc3af238e3ed157d59fefdae8b"
    sha256 cellar: :any_skip_relocation, catalina:       "9d92bd28618434e28fbea81c253b03468075f8dc3af238e3ed157d59fefdae8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38090f886fc7f9837e0f8df52c5165d9be356cfca0ad012307e04f97105aa5d"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2f/39/5d8ff929409113e9ff402e405a7c7880ab1fa6f118a4ab72443976a01711/charset-normalizer-2.0.8.tar.gz"
    sha256 "735e240d9a8506778cd7a453d97e817e536bb1fc29f4f6961ce297b9c7a917b0"
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
