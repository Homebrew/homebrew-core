class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/88/27/418ac6f1b85856608df81fe6e72fbb85929d7b904540056f3061e27bba04/fonttools-4.32.0.zip"
  sha256 "59a90de72149893167e3d552ae2402c6874e006b9adc3feaf5f6d706fe20d392"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3913aa62ccdda0caf2bcd613fc0a2d2592f182e2e3fe560d722b7876c224371a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3913aa62ccdda0caf2bcd613fc0a2d2592f182e2e3fe560d722b7876c224371a"
    sha256 cellar: :any_skip_relocation, monterey:       "8ed42c1a2f9f955399ab4b7db0b9ef724d0bc1ba1ca77e09e748a3486b21ed7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ed42c1a2f9f955399ab4b7db0b9ef724d0bc1ba1ca77e09e748a3486b21ed7a"
    sha256 cellar: :any_skip_relocation, catalina:       "8ed42c1a2f9f955399ab4b7db0b9ef724d0bc1ba1ca77e09e748a3486b21ed7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1c3605a0fb146fd2f0aded0bd06f833889dbd766e79d8edf4845e729978ff58"
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
