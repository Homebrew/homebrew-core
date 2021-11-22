class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/3c/d5/f722e0d1aed0d547383913c6bc3c4ff35772952057b8e2b8fe3be8df4216/fonttools-4.28.2.zip"
  sha256 "dca694331af74c8ad47acc5171e57f6b78fac5692bf050f2ab572964577ac0dd"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97fce3ec5330c878922b1fa75ea2a59159d6f64cf23970fcc4002fda844922ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97fce3ec5330c878922b1fa75ea2a59159d6f64cf23970fcc4002fda844922ea"
    sha256 cellar: :any_skip_relocation, monterey:       "57e6ff73ba7945dfde0227413a69e984fcb291d333ff53447e649bd063530d1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "57e6ff73ba7945dfde0227413a69e984fcb291d333ff53447e649bd063530d1b"
    sha256 cellar: :any_skip_relocation, catalina:       "57e6ff73ba7945dfde0227413a69e984fcb291d333ff53447e649bd063530d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47edc19b0e0dd59c31c9f5ced3ba45d74185bd7c28473079013539363c94d8d9"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
