class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/1.0.0.tar.gz"
  sha256 "9e2c892f0cfd7e10cef9af1127fee6c18a4c391463b9fc50574667eec4ec2c60"
  license "MIT"
  head "https://github.com/auriamg/macdylibbundler.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6083d2e13e728861798d84a45b48fd1b575d77c6f709628a49f551869887e375"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7560a5028b5bb8300dcf33492c54f7fc148c9cd7af0ae58aac40184cb7d28de"
    sha256 cellar: :any_skip_relocation, monterey:       "fe11e829e5ae179c04a7a576f4536fc59470a0c5a31623a7a8cf5ab0606abdda"
    sha256 cellar: :any_skip_relocation, big_sur:        "62008e896c348f9714b20c04696595d0e858dd56457845de973c8089b83bde66"
    sha256 cellar: :any_skip_relocation, catalina:       "ca4b42c902bd1ac60982c99415bb32e7faf3a7be6ef2f40c6961c2e6828daeab"
    sha256 cellar: :any_skip_relocation, mojave:         "401e1ed1a81e08b88c5c3515677b8b5acbaa11c8c5b9f5ea854a3e8aaa3a4a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b2307946efce558f78aaea82b9abada919dc1e70cbf214fcb012f3fda12ff3e"
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end
