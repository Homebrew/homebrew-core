class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.4.0.tar.gz"
  sha256 "762dbe5f2a0ea84078b194190f4fb51b9fe3e6ef043c1899fdda6a083328225f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b408e7de0b8d0d3634deac27adcf630e303dcf03eee853a16af4b8b9d2f75714"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b408e7de0b8d0d3634deac27adcf630e303dcf03eee853a16af4b8b9d2f75714"
    sha256 cellar: :any_skip_relocation, monterey:       "b408e7de0b8d0d3634deac27adcf630e303dcf03eee853a16af4b8b9d2f75714"
    sha256 cellar: :any_skip_relocation, big_sur:        "b408e7de0b8d0d3634deac27adcf630e303dcf03eee853a16af4b8b9d2f75714"
    sha256 cellar: :any_skip_relocation, catalina:       "b408e7de0b8d0d3634deac27adcf630e303dcf03eee853a16af4b8b9d2f75714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31d98acdc362571796f04dee5c4fca5ed0949a5cf7347c024de713764f68a3c1"
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
