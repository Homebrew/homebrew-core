class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/a8/73/93eb9fb5e296700470108495ec128708b8e15a09f3cd32145a3b7b6f4a12/gallery_dl-1.26.0.tar.gz"
  sha256 "fa0e2d7ebed117daeb8a641c5e1733de8fc2c7dc4b36b4c3575171ed74b187b2"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f34fcf9c0a70d9bee5095933cdc9efe43a9467dc2ece663bd938f689bd26c994"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bb9206f488ced3fde129dc3337b42cdb2de10e844a2090c87c95af91c9ab5f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69d8e761e43149fa220fcc0bcbc538ab5436de09faacdd335e0a5b588dd2c23"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c4078009abd5021739f32f2a961c1b41446d94a53bad6074ca917d32dd2c638"
    sha256 cellar: :any_skip_relocation, ventura:        "8a29925fbb4dc7662e19b55beba00824e39346941b966410f20abf7947eca97e"
    sha256 cellar: :any_skip_relocation, monterey:       "3933ee5958338b9ad47ccc3e967bbf964234f868d8297a64e6eec555b2a9f769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb380daf5e052ef8d60b5ad742834843474f83500cf61be1a4b680c0b4947770"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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
