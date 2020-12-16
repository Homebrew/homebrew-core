class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/2.1.5.tar.gz"
  sha256 "31182a63f2d2002e5dc99e8f809157c18e660a9964cbbc9faa249e131493c635"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b88284143788c5087624b04d751dbedb156e896bfde3ed346b98086ee344524" => :big_sur
    sha256 "79d8984a41b38f074d1ec4012e5dc88141385ac65f0c56cf6dafd6d6b3642011" => :catalina
    sha256 "ccfba6e85598fbbf8530070b04b9534cafa9ebf53817926f6c988e5281580929" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
