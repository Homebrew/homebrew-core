class F3 < Formula
  desc "Test various flash cards"
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v7.0.tar.gz"
  sha256 "1aaf63cf73869633e7e03a2e12561a9af0b0fbba013a94b94e78d2868f441d71"
  head "https://github.com/AltraMayor/f3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43e671cd918bb967db742930a092fe814b366a2293613797b13c376c190d7dd9" => :high_sierra
    sha256 "e10885461941cca0ed989763d1677e0322c2b7e542710dd7104ee34c0508710b" => :sierra
    sha256 "1b3eb529dd5ed455ecc8c1420c9fa1011ca84fc841fdb1570b5651ce171b988f" => :el_capitan
    sha256 "ea3c848931257bbeb60e85a672d7132556528646bd2b1f5e35ace60461b80a34" => :yosemite
    sha256 "96ee5681212139b960fdaca98839e2e5e23446f1b890b751c459b05bedabaf6a" => :mavericks
  end

  depends_on "argp-standalone" => :build # static linkage

  # Fix undefined symbols errors for _argp_error and _argp_parse
  # Upstream PR from 21 Dec "Add ARGP to Makefile"
  patch do
    url "https://github.com/AltraMayor/f3/pull/67.patch?full_index=1"
    sha256 "243f15c42b0e4561990fbd57add0096c2d09e49a5c4a972de1458dc9b71c908c"
  end

  def install
    system "make", "all", "ARGP=#{Formula["argp-standalone"].opt_prefix}"
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
