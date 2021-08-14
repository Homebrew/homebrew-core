class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/d1/0c/351dd4ec8352b0496aad7a282b9276572943a08b1ce28a71295438ebe789/gallery_dl-1.18.3.tar.gz"
  sha256 "6e058dd25a8a54ead41479579fd73de71472abb980a6254765c5e538b591d162"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4140df643ee4b06c7deb2fa8e02e30d67464e1232b8a189c4fbe2779acc5074b"
    sha256 cellar: :any_skip_relocation, big_sur:       "54a4641ae87f3cf68557518c66e605329b4b2051c9ddd3c04b38ea451c66f02b"
    sha256 cellar: :any_skip_relocation, catalina:      "54a4641ae87f3cf68557518c66e605329b4b2051c9ddd3c04b38ea451c66f02b"
    sha256 cellar: :any_skip_relocation, mojave:        "54a4641ae87f3cf68557518c66e605329b4b2051c9ddd3c04b38ea451c66f02b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93980b3dd3676560af5f30b17269ee9aa806e86acddd79c55732deebd70d8789"
  end

  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/4e/2af0238001648ded297fb54ceb425ca26faa15b341b4fac5371d3938666e/charset-normalizer-2.0.4.tar.gz"
    sha256 "f23667ebe1084be45f6ae0538e4a5a865206544097e4e8bbcacf42cd02a348f3"
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
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
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
