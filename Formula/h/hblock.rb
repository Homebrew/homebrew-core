class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/refs/tags/v3.4.5.tar.gz"
  sha256 "625913da6d402af5b2704a19dce97a0ea02299c30897e70b9ebcee7734c20adc"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d4a7729a5bfcc2f71e04bbcf5d271c63ff768a82558b7389c15c90bf293aecca"
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
