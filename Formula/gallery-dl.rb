class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/23/c8/456af8aa7c6910412407ffd2e4240b3439398aa8da5fe3cf5d765334410d/gallery_dl-1.25.0.tar.gz"
  sha256 "5b1987eae00c9db9976563a42e1e01eab47a455db17d254167bbf8ec0c25c116"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b149a6c95d204d2e8028bcaf2c78bbb7615902b47b8d5b94c0cebf09d40f2ca0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e418b38f3d8588cd42d24ae6b942e08f538c0a45dc29beeebb173cab56843585"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd6afbb56eb2360c36290f6f60e1324c254dcf29c69e6fcb709019b0adfa3483"
    sha256 cellar: :any_skip_relocation, ventura:        "391de40c9124799dde69529c30b8e29e7cf0f204e2549a0549cdcd927090d500"
    sha256 cellar: :any_skip_relocation, monterey:       "f162e6424e8960d416d71777f349663ba8866cb67937fbc00c889c23c19bac8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "24056c38bb0dd728990feb2e7b5684d458edb020cebeda0c4e58c403e051624e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3756ea87544131d2ff7e2696279413b6195b572f03d23b93c55cf44ebcd7c7c"
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
