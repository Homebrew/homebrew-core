class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.14.tar.gz"
  sha256 "c019b23fc1e0e41edc757aee7ed8f37abaaa62aa7ff0bfd7cc5c8511ffd327e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "2395205bfa683bbfbebbc9fdd8ee5f03c04921f6ea80f0e9d8788c6408869f53" => :mojave
    sha256 "cf9d98d1f6df0fb1077ad81b535583ad1094c4e06ae7cb5fe62c5c2f1e185ceb" => :high_sierra
    sha256 "c3a19915d2892a7e1dcea98e1d49437c61e101e1087ca256dbca327bf2d7656a" => :sierra
  end

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
