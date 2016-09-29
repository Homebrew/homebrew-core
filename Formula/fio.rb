class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-2.14.tar.gz"
  sha256 "9fad9dd4d6304f1220023500abf07c5d20bf5e27fba95ac6edb7035939d363a5"
  head "git://git.kernel.dk/fio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d8cb0252366907d14b87ee1b10b8b2ef0019a2ef8818ea550d0b09a822a24f7" => :sierra
    sha256 "f4caaad6102651a917bcf0faf2f9547b7dcf36f64bb9e5ec4ff676fbf6466853" => :el_capitan
    sha256 "32c4f08379ac6fb031e54da94397dd4f74be1e937c8703f44602660be8e66bca" => :yosemite
    sha256 "b6ff9b7c19f2cac95bff1f75a452578788ad8f0599b981dc3dd3fd2612f77b63" => :mavericks
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
