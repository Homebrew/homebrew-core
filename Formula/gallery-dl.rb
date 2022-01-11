class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/05/e8/b0ffa679ee17e142ce2cfbcc405bd129ab1a12484285915ae9cf128c70b1/gallery_dl-1.20.1.tar.gz"
  sha256 "a1c06625381485f82aa14a038a622d40ab9cc2c8d150dd65c66df96dbf427f62"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cd9e6aa07ba69ccb5d8e3c59a2b73e8e0f25e66f895f0287d2e45b664a2addb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cd9e6aa07ba69ccb5d8e3c59a2b73e8e0f25e66f895f0287d2e45b664a2addb"
    sha256 cellar: :any_skip_relocation, monterey:       "92e9444ce82347d30d0d904d34d7e56e4cea328f8555d31052c763fb70aaa38e"
    sha256 cellar: :any_skip_relocation, big_sur:        "92e9444ce82347d30d0d904d34d7e56e4cea328f8555d31052c763fb70aaa38e"
    sha256 cellar: :any_skip_relocation, catalina:       "92e9444ce82347d30d0d904d34d7e56e4cea328f8555d31052c763fb70aaa38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "850c35d27d1a305d3d58628b88334c5aae7f20185b9447e5ff2267f7ec6e1b5a"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/48/44/76b179e0d1afe6e6a91fd5661c284f60238987f3b42b676d141d01cd5b97/charset-normalizer-2.0.10.tar.gz"
    sha256 "876d180e9d7432c5d1dfd4c5d26b72f099d503e8fcc0feb7532c9289be60fcbd"
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
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
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
