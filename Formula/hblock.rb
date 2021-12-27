class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.3.1.tar.gz"
  sha256 "649ef980871d4be467a43edfa99c636b95b5af38ee976985082a65c4989eac01"
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
