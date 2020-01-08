class Lcov < Formula
  desc "Graphical front-end for GCC's coverage testing tool (gcov)"
  homepage "https://github.com/linux-test-project/lcov"
  url "https://github.com/linux-test-project/lcov/releases/download/v1.14/lcov-1.14.tar.gz"
  sha256 "14995699187440e0ae4da57fe3a64adc0a3c5cf14feab971f8db38fb7d8f071a"
  head "https://github.com/linux-test-project/lcov.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e41c1e1b7e38279cb0e0e8e638046ffe4172ae18bd43afcb767eb52f28d822fe" => :catalina
    sha256 "2ca04e6c269ebf3587be2e485e0a6be9de81963e0a59a852c3be227bcb43919e" => :mojave
    sha256 "2ca04e6c269ebf3587be2e485e0a6be9de81963e0a59a852c3be227bcb43919e" => :high_sierra
    sha256 "e6d2a1d121c878d81d051de0f9f7fbda37c438a620de9c99d0a0c7540b5f61d1" => :sierra
  end

  def install
    inreplace %w[bin/genhtml bin/geninfo bin/lcov],
      "/etc/lcovrc", "#{prefix}/etc/lcovrc"
    system "make", "PREFIX=#{prefix}", "BIN_DIR=#{bin}", "MAN_DIR=#{man}", "install"
  end

  test do
    system "#{bin}/lcov", "--version"
  end
end
