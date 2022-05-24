class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/de/54/14376a4e5c1e7d2105a5be33ad5584b56e36753dc615506728a1489071cd/fonttools-4.33.3.zip"
  sha256 "c0fdcfa8ceebd7c1b2021240bd46ef77aa8e7408cf10434be55df52384865f8e"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56f41f0375107a44669e6a82555de8b22f2867b47bc16dfaba7f4ff2e0a9cabc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56f41f0375107a44669e6a82555de8b22f2867b47bc16dfaba7f4ff2e0a9cabc"
    sha256 cellar: :any_skip_relocation, monterey:       "97e2a260bf9c29b0c35b389c2ccb5b502a98ef218f2ea7ca9cacfff3e0fcefa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "97e2a260bf9c29b0c35b389c2ccb5b502a98ef218f2ea7ca9cacfff3e0fcefa4"
    sha256 cellar: :any_skip_relocation, catalina:       "97e2a260bf9c29b0c35b389c2ccb5b502a98ef218f2ea7ca9cacfff3e0fcefa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7140d4b1148c215d469beee9d1f15cb330398e7051893c8edf800239a778044a"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
