class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/65/94/ed2512252e56090092a9852e7c3a7f24f9dda66ca5dfb40fade0c3b6151b/gallery_dl-1.22.1.tar.gz"
  sha256 "1811b8d841fc531e6770b3e8d3bae3c87c999caf3ffaf7790630029781fe9301"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b7dceec15f0d96d063555d841a8ad7b3ca1d5bbf234307af8d1e58c79e56a1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b7dceec15f0d96d063555d841a8ad7b3ca1d5bbf234307af8d1e58c79e56a1e"
    sha256 cellar: :any_skip_relocation, monterey:       "1eee0ae2bf0e841dd59678afd95565a002c11ff59c22222d88f200c44bcd1797"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eee0ae2bf0e841dd59678afd95565a002c11ff59c22222d88f200c44bcd1797"
    sha256 cellar: :any_skip_relocation, catalina:       "1eee0ae2bf0e841dd59678afd95565a002c11ff59c22222d88f200c44bcd1797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "287131269c6c801e3fc6260d183d5f1af16a5f0b37b5f98d4ed473c214128b22"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/10/75277f313d13a2b74fc56e29239d5c840c2bf09f17bf25c02b35558812c6/certifi-2022.5.18.1.tar.gz"
    sha256 "9c5705e395cd70084351dd8ad5c41e65655e08ce46f2ec9cf6c2c08390f71eb7"
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
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
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
