class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/ac/86/022e5c3a31072a57080ab01e791b82e6746562a0a3b0819053f33626e6e7/gallery_dl-1.25.2.tar.gz"
  sha256 "4fd3f3be339d70b68eee24f1059c6e71076200f569935fbdc037dca5284805d3"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "501a58d14f9347437502ca93e0e12aa5273954150e718d685e5e07bff657601a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c5425529c0a3aaad07ecbd8a7bec30b5b33acfea8c35696c64f469962ab9c4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e02a74abc713bd873fd6518cc8560e09e6ba940dc64c6493904e73ec9755f268"
    sha256 cellar: :any_skip_relocation, ventura:        "10f3ba3a7f1f3352277807d35548f7210fc2da4fe2ee3a1278abd521f963f691"
    sha256 cellar: :any_skip_relocation, monterey:       "d5675ce0d5f0a2ec73ec8b12fbffb44e648ea986ce1c60f437021703d7a160dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c89c7be527971cea33536a7d2a3772e882b93058eaf7ef5cc454b944514d329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91136249404be7be655b872a5ae58d11daf0f96ca6333100b367ee643a60904c"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
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
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
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
