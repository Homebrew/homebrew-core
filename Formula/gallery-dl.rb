class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/18/fc/a4af2c1e8de06c46464d67b3cf3993914d9a9b1ce1d6e3840ae82a90f09b/gallery_dl-1.25.4.tar.gz"
  sha256 "e31d178d7ae21002564a66c68c15b16795895bdaee184f7056b7596137bac04e"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3575d68f890f51954f2e2ba199ae1f691789850807cd73fcee0eda11ad7756fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff77673f461ba29dbdc06418a241227ffb8e6a1b8de90c40f7465ad6a2f15937"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "286789a98b9c22acac56fcf8499067d63d0e88609af68da2dd81b939894e659f"
    sha256 cellar: :any_skip_relocation, ventura:        "74e5ca4f65a776703bd749d108af76ab85f510bbdeed1d0dc97c7bf812a12a43"
    sha256 cellar: :any_skip_relocation, monterey:       "bb5239c307d7098edafb6781035617fec959ca112d1739119cc07e7e1b248a8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bf8c0fa55501968c104978291672ff067a3a7e84446d116f54f7f1293733214"
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
