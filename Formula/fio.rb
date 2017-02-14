class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-2.17.tar.gz"
  sha256 "4d31ce145cc2d21e91aaf08bb4d14cca942ad6572131cba687906983478ce6e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "08c04dceee78e15833417c2672940f83334cf8a5f552f28802f7d117e1ae7c5c" => :sierra
    sha256 "34eb8a018808964010f9b626a81c268b3e704e4c3e02f9c75b4e2f8428173a31" => :el_capitan
    sha256 "fcf155cd769b1328c40423c7081d34b37d585bc918d0d8590500c25aebf0b59c" => :yosemite
  end

  # Upstream fix for "dyld: lazy symbol binding failed: Symbol not found: _clock_gettime"
  # https://github.com/axboe/fio/pull/309
  patch do
    url "https://github.com/axboe/fio/commit/ccf2d89d39.diff"
    sha256 "6a714e9e40a8973549977bc3ae3b7d8fa7a6a25dd8c9d385fe8e0e58006339fe"
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
