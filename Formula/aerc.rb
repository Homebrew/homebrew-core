class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.15.2.tar.gz"
  sha256 "722da196e8807c497f5472704b8a1737d7780ad0faa7166ae83348bc67b144f7"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_ventura:  "2b774d0651b29ad19b042dec94798a317f2a7606f5857420f42068e2111d8aca"
    sha256 arm64_monterey: "7fa8fd4472c675e37bcf4bdd24a6ba7cd433f21e6a999f422672a1e074dcf004"
    sha256 arm64_big_sur:  "d0c415766fb1f059270d548991926380faf7442fddd1431fabbf6f90adaa271e"
    sha256 ventura:        "5d999ef114ce22259f9cb9450faa3853449dfe5f9e24c0d10e46bcb6cd7f7915"
    sha256 monterey:       "614318bfd55d90e03e8615cde9a7c47cfacce4487f54513076bc895ea5daa874"
    sha256 big_sur:        "25ad7fda059858a57a72d51f1a1188d1c7db8f8a8919df914820d4e8f74064dc"
    sha256 x86_64_linux:   "3ee5538f6e3c12ea5c7034f3171d4ccc535a49f3f7248b12fcf0877858284e12"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
