class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/99/6c/3758d0f6f08f3d1cd08cae15541fde93bb550bb750be8e12a2b4d8c8be76/gallery_dl-1.24.3.tar.gz"
  sha256 "bb9b4508e443bca1226a89dd2ffc0f5f264ccf44def2f6ae8502d85e29b52ac1"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1b623d11d4c24d5eff90500cce672205a77b118070f87af1467dc4962989bcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1370184b1fb363794f4f775991bbc4dbb1bc11f615770aef23724fd3372e014d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "997208481c0b398971d58b1416a443cf5fdaf57b8c2bfcf0841c1b27bdd97c16"
    sha256 cellar: :any_skip_relocation, ventura:        "bf2f0c05de6cbd67d29c9cfb1aa3f0f7d774ecd29c9449de9163aaed7b3eee4a"
    sha256 cellar: :any_skip_relocation, monterey:       "d524416e1c95cf799142089b66b53059c0809e8c90e4a13473826d93d149be5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa65f2ea62ea6c1eb71e4fdfa95a4312830a6f7fc77e0ce5f483e0aa58da6180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e47b0520ff0708251224fbfca0c030c15ec6a40621dda5351ade06246fb7951"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
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
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
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
