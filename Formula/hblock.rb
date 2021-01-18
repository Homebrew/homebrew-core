class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.2.0.tar.gz"
  sha256 "a5a86a0e9913d88dcba7270c9e3ed37f4c626c8a6a8b5e9303a8a173824bdfee"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e983c78b4e45ffcef65cea8dbd253d0c7893670dd2edebfd489c234598122b0c" => :big_sur
    sha256 "f4a73b36a9d7e96dee2632760f5bf4d449f0445d9f782b88726ab12d1a544695" => :arm64_big_sur
    sha256 "400142a4275501a8ea5630260a41169e4b2bd9ab711cd4053bb716ac14510c52" => :catalina
    sha256 "631a6da27cd7728a9c87caed412ccfa1236a8023385bbd623b482609a18cc30f" => :mojave
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
