class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/be/e2/6a78ecdbfe1d15575a46d17a17468a0f52841ead6da38d94bf57b14e9ea0/gallery_dl-1.22.2.tar.gz"
  sha256 "b0435f55d12df53f2edcb962535d74ee36576943c085df7f0b19b4e006bc2a8c"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42e0699bc9c711b7cf838655c078764c5a292559d5f18ad92664f506d3197e0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42e0699bc9c711b7cf838655c078764c5a292559d5f18ad92664f506d3197e0c"
    sha256 cellar: :any_skip_relocation, monterey:       "48e682747446f095f9ad0796f242ef5c1f0b5e70cfe2d56d35ad04e0ed0989f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "48e682747446f095f9ad0796f242ef5c1f0b5e70cfe2d56d35ad04e0ed0989f0"
    sha256 cellar: :any_skip_relocation, catalina:       "48e682747446f095f9ad0796f242ef5c1f0b5e70cfe2d56d35ad04e0ed0989f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77144c9a93473410e2ba9105b15aa1191cf2babcafa801245fc1ad9bb42bc565"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e9/23/384d9953bb968731212dc37af87cb75a885dc48e0615bd6a303577c4dc4b/requests-2.28.0.tar.gz"
    sha256 "d568723a7ebd25875d8d1eaf5dfa068cd2fc8194b2e483d7b1f7c81918dbec6b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
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
