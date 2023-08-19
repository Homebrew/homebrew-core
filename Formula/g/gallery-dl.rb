class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/7b/b1/7695f743070f369d76b802372faeec7a4ff4a43327d8942c54d5f5091eb9/gallery_dl-1.25.8.tar.gz"
  sha256 "eaad85f73486669d2266806f39422e204a8db3dee16ec6f3136dd72724d95037"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15809a724a7ecb8460f6b1a31a8c3dd487d3db3ae855f4ef844eb629595e0ca6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "772197c1740c4a4cf76a6800c41335c5169b8ca07a25e3a226194d679df7390f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54504ee2a636e07985a2fc781693cfafad7961432f58e8a81a419aa9bd47d28b"
    sha256 cellar: :any_skip_relocation, ventura:        "ea3994b29450abe1c7601003f04aa3203b730c0351c707e70febd8f4e67b680b"
    sha256 cellar: :any_skip_relocation, monterey:       "f48275647e74622d59965f9bb1d7110ee7aa95f4022ade1dd72155b3c7e09989"
    sha256 cellar: :any_skip_relocation, big_sur:        "c566b11083df7d8e1d915ec1d626669055694ae797da5b0bac67c7cd0fe50e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0da6c094ec16f44a23a35d4e8dcb4895eebede063af843067015dd057053425d"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
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
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
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
