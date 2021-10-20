class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.2.3.tar.gz"
  sha256 "1b8eb3c5cb074cbe7b0a8b5e040641c12b519bee21a4a879e1bdd328cd17aa60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5555d355527123587a90da7298f5924a5ce6af34459cedd63f7afaeb0e2c9935"
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
