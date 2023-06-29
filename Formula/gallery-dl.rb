class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/60/78/176e7c4310a6c200372871a005da8ee5447c0e62cd3533172e009b71a94a/gallery_dl-1.25.6.tar.gz"
  sha256 "0824ceff5b7a9482b69d02adaa05aad07026efad2de6d3a183cbfdf7352463f5"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aff08c5c648bc87f57708f391651badc02cadaf9ffdf5415b118937a251a2d98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a9cf75cc20f257bb2da1381b012bf8dbfabfa48e6f0780029b1754fc1fae35d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be456c446f231c4baf61bca8605ffa27c5dce87fc291da7d1fb8148db262dcc9"
    sha256 cellar: :any_skip_relocation, ventura:        "684582baad904cb0d0efb2ee76e761e9bbb86b3a5d6c03d0bb667bb07139963c"
    sha256 cellar: :any_skip_relocation, monterey:       "b00f85ba67a2c408e8a37ef29ae4513019dff06d28e315a2928820a4f6766e72"
    sha256 cellar: :any_skip_relocation, big_sur:        "03bfb0845c65d494f7fb5dc6d8067efc1f178e3e1d21b33058a4a1867e6e54ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24b04fba492f7557edb582d7930b2c8e98bfbe9aa3d9b13d58c3beaabb77aa3c"
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
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
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
