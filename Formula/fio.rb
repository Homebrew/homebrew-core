class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-2.17.tar.gz"
  sha256 "4d31ce145cc2d21e91aaf08bb4d14cca942ad6572131cba687906983478ce6e5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "80b4ccb0ebffb0219ccce055aff65f4d0288e52adc74ac3ae12c09dd4186f7d5" => :sierra
    sha256 "958ccd2531a841bddf5eac1113156bd992bcccd6bdbfd8cc74e7fdd28fe4097e" => :el_capitan
    sha256 "a29b96564d86834fd3c6358a164d7d687372e0ae3c9698f49681d53f283afed5" => :yosemite
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
