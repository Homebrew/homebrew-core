class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/a9/9e/c5bd12aed4f1bb46bbcc2279ca235b2f4e84b17f58f574400bb4bb8c1798/gallery_dl-1.27.3.tar.gz"
  sha256 "20b9e76e7422267041395f3b996c35c4753c0ed097215570470cff3dfcd54922"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ee18861028f328a4218576232ec0d55482820a23bee06f2de6a37aafddb33c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ee18861028f328a4218576232ec0d55482820a23bee06f2de6a37aafddb33c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ee18861028f328a4218576232ec0d55482820a23bee06f2de6a37aafddb33c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ee18861028f328a4218576232ec0d55482820a23bee06f2de6a37aafddb33c4"
    sha256 cellar: :any_skip_relocation, ventura:        "7ee18861028f328a4218576232ec0d55482820a23bee06f2de6a37aafddb33c4"
    sha256 cellar: :any_skip_relocation, monterey:       "7ee18861028f328a4218576232ec0d55482820a23bee06f2de6a37aafddb33c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "072673cfb44a7b3caf4d89d620b06cb0bfb3bff748961a72cfdefb03d4fc7421"
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
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    system "make", "man", "completion" if build.head?
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
