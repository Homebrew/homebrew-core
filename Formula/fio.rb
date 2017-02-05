class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-2.17.tar.gz"
  sha256 "4d31ce145cc2d21e91aaf08bb4d14cca942ad6572131cba687906983478ce6e5"
  head "git://git.kernel.dk/fio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08c04dceee78e15833417c2672940f83334cf8a5f552f28802f7d117e1ae7c5c" => :sierra
    sha256 "34eb8a018808964010f9b626a81c268b3e704e4c3e02f9c75b4e2f8428173a31" => :el_capitan
    sha256 "fcf155cd769b1328c40423c7081d34b37d585bc918d0d8590500c25aebf0b59c" => :yosemite
  end

  def install
    # Fixes "dyld: lazy symbol binding failed: Symbol not found: _clock_gettime"
    # Reported 4 February 2017 https://github.com/axboe/fio/issues/305
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "configure", "return clock_gettime(0, NULL);", "return foo();"
    end

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
