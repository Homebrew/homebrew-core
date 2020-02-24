class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.18.tar.gz"
  sha256 "7f84b1670f2ee78deead97b26d836c0e7b46823bb1c776e8fe7ce28cc794869f"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cdd4229f4ff2a6667e8f988060f3329b86fee7a248c2cd6621cda98d7cbbbb1" => :catalina
    sha256 "cd198b83837dfe8eb61ffcdd81bace6ea8eb233af0b9dcea711a3491c0953fcc" => :mojave
    sha256 "1be63b9cabc31f619226bf5d7e653366f05ff3bc9beba15731654e9fe5e77579" => :high_sierra
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
