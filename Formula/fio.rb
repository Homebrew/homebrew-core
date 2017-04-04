class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-2.19.tar.gz"
  sha256 "61fb03a18703269b781aaf195cb0d7931493bbb5bfcc8eb746d5d66d04ed77f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5fdebb5e199ae1f4de54b138001878d4b0e06b6a460c448e279ba1558e261b9" => :sierra
    sha256 "e92f098309bf28511e93300b7c638aece66c7c62bdd3c4c907cef31c264a7f30" => :el_capitan
    sha256 "a7f527088798e2f4c94fff1efad84778a1703c6a330e6b3325713df5fa1d70d4" => :yosemite
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
