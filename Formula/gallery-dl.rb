class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/48/5c/573b125a6b187f1d3feed1dfb524269be6008a29009600b94236aa81452b/gallery_dl-1.23.3.tar.gz"
  sha256 "0a864dd1c2d74ae8d94521855f776c346baf82ea5ae2dd55ac4a16f99bb8d72c"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db17ce6e2ed9c70dd949e02edc79b259dee1fef32e0d5dde98bee571d00576fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56310bea120d506b76668cb5f8e93b1b3701ad77b6f7df863cf81d7931b9c0da"
    sha256 cellar: :any_skip_relocation, monterey:       "0bbceba07af905f39abe101ea0be5d6a946ab47cd16034f29e6605e5f776bbfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "61da7b571b9ee4a904b0be85c41ed626142ba18b69ce1ac05047ef939ca55504"
    sha256 cellar: :any_skip_relocation, catalina:       "0fd94fad0dfec177ba55fde190a1d94306a108c936046730a1bac5d18f103f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28806e065dcc2213f4dffa6c297d7893a17a6927701d6823499a2bee8668e525"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
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
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
