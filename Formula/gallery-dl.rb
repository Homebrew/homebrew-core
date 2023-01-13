class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/d6/3e/9b4218eaacba3923fbdb2f7034bdd32eed1f3b94320a20978108003f8107/gallery_dl-1.24.4.tar.gz"
  sha256 "83e9db1e96e8e8ee33a03266e8c47009763da4cef7355ed1291e7db3ef0b335d"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c17b795b81c07c955fea94acd5e94c20e84de03d9f23fbdabe934bf2851e7532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16ac1d5f875fa71e8677229f875eee7697d14ebf5a8bbe9cc70246b4824e5010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a89c3803904b53652f78a7d7ea94108851f85e7224308106e2a3d0e52f84e5a"
    sha256 cellar: :any_skip_relocation, ventura:        "54de3ca3a2474867fcd339925abedaac7951c4a916363f5c636a750c4873d5af"
    sha256 cellar: :any_skip_relocation, monterey:       "9fdb06c79cc8e91a587a49fa91784a12e61263cb398b80ba1e08810e526ccc75"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d633a5ec2da343ae62290ec82d0a10c53357a916aa2ed03db8989601b80c200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97d0897383d3d22488ad4dc5b2dee594262b2caa953a977806b07ad7480ef979"
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
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
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
