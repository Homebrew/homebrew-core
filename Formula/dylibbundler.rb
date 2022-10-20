class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/1.0.4.tar.gz"
  sha256 "839c6a30be2c974bba70ab80faf8167713955bb010427662b14d4af7df8d5f19"
  license "MIT"
  head "https://github.com/auriamg/macdylibbundler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "906a8b5293262c5416a17657e70bd7283ef007a2eaac10b0627729f14da3d685"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0c87ee93247dfb14af9096049d1eac119b2f52bed32eba7e8b7743ff3de76c4"
    sha256 cellar: :any_skip_relocation, monterey:       "7459d9405ef5405c0be7fbc6db4987fbc4a4ce1dbca93c8902b945dd7b9d3307"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6699edbfc9c65203e3dba211bfbed054e1c98420155f7aa2c90c2c08de1419d"
    sha256 cellar: :any_skip_relocation, catalina:       "f0e0cb6d2d0f852911795684b2817a13357c16077f153fead1e40fdc0e84edfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f64c147777fe104678a78648a73fbed44471f02ba99698d382565f26b20c98"
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end
