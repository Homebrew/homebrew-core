class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/2a/01/231b56657860045a8db431ba2b522d922eb738174c53d27ae8c6eb0ba4f0/gallery_dl-1.23.1.tar.gz"
  sha256 "2443c60b00bcd67008a618a7c03eaabeb922a5a1d3b37fe4ae802b82a86dfdf4"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2dc5146e9a918e11ba6f0b4e1f69382c8eba571e989e1fdda1d6aa596a7e4d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57d6d542ca7ceda2ee77d6f6a1e7acf2731fa567a730aa4298aaae18669d4843"
    sha256 cellar: :any_skip_relocation, monterey:       "58411d57c5f863c49471625a95949841b1b1773dc366ff7df92822934aa2051d"
    sha256 cellar: :any_skip_relocation, big_sur:        "013c1a764c04a9e5d926e36994ff30e8197197dbb9d4396aec4b49cd345fa40e"
    sha256 cellar: :any_skip_relocation, catalina:       "393f84691e278885dc13dda8c400bda2f9d063f4edef8b746261ebc595315a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "961b09fa7c507d8cb425e83715d6b73d60bbd320d4d9247187f4aa5500554afc"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/ca/48/88ec470f8b68319b6782ca3a0570789886ad5ca24c1af2f3771699135baa/certifi-2022.9.14.tar.gz"
    sha256 "36973885b9542e6bd01dea287b2b4b3b21236307c56324fcc3f1160f2d655ed5"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
