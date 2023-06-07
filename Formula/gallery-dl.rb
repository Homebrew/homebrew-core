class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/77/f6/f62a94277168fd5f2adbed55f2358250b0aa3eb9508847fedb73090e842d/gallery_dl-1.25.5.tar.gz"
  sha256 "205cca54722e659d962e4db766acb1bf0c57178e5fd8efd502a43f8fdf31e1a8"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1cd1fb937d30ea4544a85a243d8c5c2b500b92b082489ed0adb40aeed9d0d4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e510435f9ff3937b5f29152b0cc0210ea4cdb3e35c8c55f8f7a9e009d79e1b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eeb1b0a1ce451afa077b25ce8c8b2c5de3e30b41cc9fb2d1b881dd4dda96e305"
    sha256 cellar: :any_skip_relocation, ventura:        "16b89aa75a824b47b5a3a1a768813acb7e1921123cc611bf4442a07b784d78ba"
    sha256 cellar: :any_skip_relocation, monterey:       "778290dd30922e780e31a62d3de6c484364a1322109574544a29a9f179d4ceee"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fe7f9cb6d5f271c024e25cafaa3c51ec05ebbfaa1c048b915c668a977990697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23f531c989c8a5a7ebf85d7449db3cc08cc9dfb24f9cdc800547378dd9632439"
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
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
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
