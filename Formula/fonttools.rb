class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/0b/f9/fbd1287671d35f8984be7952d61c0d968df9794e2d5009513424201d9264/fonttools-4.39.2.zip"
  sha256 "e2d9f10337c9e3b17f9bce17a60a16a885a7d23b59b7f45ce07ea643e5580439"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "885966c90301e8d280171fd741271e300b269efd8f7b567760b4420ea3459949"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fd1e67dc1776cc598d243bc24d8b5815236a5c4af9ad68d395eff594b3145de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1a9efd3f1b4432f92fa0ad8a336a2823c563d24892a7670cb1cd41926a1bc31"
    sha256 cellar: :any_skip_relocation, ventura:        "9b3fd5a68e27409790acc01a127c2ec13dadeba3a1fc25cb61047082428b7bed"
    sha256 cellar: :any_skip_relocation, monterey:       "721968936132f7aff4bd3f3d525fdfc31828be5d6074d1e961c66181f0ee34ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a89330a48204075a9863e18f81e547682631886d0d61c8fcf916c1b784089f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c30b8eac211097efbfe0e0248a4c9d7a2dd94eec25f29267c7f3771b433d9236"
  end

  depends_on "python@3.11"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
