class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/1.4.2.tar.gz"
  sha256 "01fc4e8adc6a61955c309cb8e8576048e35c45d6a9da002aa4589e06dc736029"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fb58677ebe4f07259ecb13fd99fd33f0615e299b33bd795cc1265c9e8b87a3b" => :catalina
    sha256 "aa68cfb8a2067b135d29733ad09eeeea55d0e4251875f3315e5825b50c3259ad" => :mojave
    sha256 "cf9208bf3f788edb1b7fd2dfaf0d290af0546738cef8eae9ce3c61142ba73962" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
