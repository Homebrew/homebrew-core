class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/12/30/9afa8353dca40bf1fd98f83deb36f52d12619b786ad028b8603da2819d0b/gallery_dl-1.26.9.tar.gz"
  sha256 "3e06dfa69c890a9805ba90509e0f0c50f8a16c39a2b780bec569d2cc2272bb99"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3501bb45a8f8140b9faff7fb5ae39fea345c6366e4f2e3bc1438909644f291c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3501bb45a8f8140b9faff7fb5ae39fea345c6366e4f2e3bc1438909644f291c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3501bb45a8f8140b9faff7fb5ae39fea345c6366e4f2e3bc1438909644f291c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "3501bb45a8f8140b9faff7fb5ae39fea345c6366e4f2e3bc1438909644f291c0"
    sha256 cellar: :any_skip_relocation, ventura:        "3501bb45a8f8140b9faff7fb5ae39fea345c6366e4f2e3bc1438909644f291c0"
    sha256 cellar: :any_skip_relocation, monterey:       "3501bb45a8f8140b9faff7fb5ae39fea345c6366e4f2e3bc1438909644f291c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b3acf956e22ef351155b486a686ba26a9be7ba7aa1a12021f6910bbe41fe690"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    system "make" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/gallery-dl.1"
    man5.install_symlink libexec/"share/man/man5/gallery-dl.conf.5"
    bash_completion.install libexec/"share/bash-completion/completions/gallery-dl"
    zsh_completion.install libexec/"share/zsh/site-functions/_gallery-dl"
    fish_completion.install libexec/"share/fish/vendor_completions.d/gallery-dl.fish"
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
