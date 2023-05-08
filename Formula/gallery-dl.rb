class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/18/fc/a4af2c1e8de06c46464d67b3cf3993914d9a9b1ce1d6e3840ae82a90f09b/gallery_dl-1.25.4.tar.gz"
  sha256 "e31d178d7ae21002564a66c68c15b16795895bdaee184f7056b7596137bac04e"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb9b056e9e3a7dd7e327d3970f9fa7e6f4ea366c9a6a0a1f0e44c88b88bacd25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b291638b1116b9b09ebf3016026f415ab56c360011244ed00af19af8ee730e3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e418f4cd04a2f467492451c27595e80f18e39167fb96edc6aaa13bdb6b99078"
    sha256 cellar: :any_skip_relocation, ventura:        "11d7db20597d54c605b867430f00512fcd7932a316be750d9614db844b117253"
    sha256 cellar: :any_skip_relocation, monterey:       "0131fa6b979aca40506eb681a6f822f8cd61f50811e4630e9fc1b860a13c7d4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee2c6d704b2c442e030cffc3c666b781e24f5124a1b3cad3f163c535522f9e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11daf22ca6802b3f259703d218560c3f5d52abd5d2deeb05955c81f11dcd7004"
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
    url "https://files.pythonhosted.org/packages/e0/69/122171604bcef06825fa1c05bd9e9b1d43bc9feb8c6c0717c42c92cc6f3c/requests-2.30.0.tar.gz"
    sha256 "239d7d4458afcb28a692cdd298d87542235f4ca8d36d03a15bfc128a6559a2f4"
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
