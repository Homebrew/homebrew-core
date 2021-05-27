class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.27.tar.gz"
  sha256 "4ba3cb1be56521456b80a5b6f5ce81e891e5de1305c45ef17e8182bebe4545b4"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "949a998dc431640d091b39ba4d3ce25903964b520e69100d67cd1a3fe91cb3cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "443b0bd05c862371e76f9f19e852c30610f0816ba1942b9e35a3344211e5b92d"
    sha256 cellar: :any_skip_relocation, catalina:      "b18a7907fab50e9214e195a8a9b108c9d66a74021603fe06ecab06bc98519269"
    sha256 cellar: :any_skip_relocation, mojave:        "c966e2007d05310a20f846ac51477201f7efb09d09762d9fdb10529a1975ba8f"
  end

  uses_from_macos "zlib"

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
