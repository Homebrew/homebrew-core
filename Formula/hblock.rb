class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://github.com/hectorm/hblock"
  url "https://github.com/hectorm/hblock/archive/v3.1.3.tar.gz"
  sha256 "e7dad9febc5205f19b36ce9268a41374931d27e0195a2d7504b62c2d1721ab7f"
  license "MIT"

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    system "#{bin}/hblock", "--version"
  end
end
