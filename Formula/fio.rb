class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://git.kernel.dk/cgit/fio/"
  url "https://github.com/axboe/fio/archive/fio-3.2.tar.gz"
  sha256 "5f54652d00858fe933902b0dfd0cdbc7bd4278e5de5e84bb8df43f15b33a146a"

  bottle do
    cellar :any_skip_relocation
    sha256 "666a13e96fda22adda6298b663f078065f59adeda534256868262f59b9ba14c6" => :high_sierra
    sha256 "994a6a2a975470441505829fcaa5f76d8c9a23a9c2813807e90e787ef07b3fe2" => :sierra
    sha256 "02fb2348fb2c21842a47a52cb51ef458b40c743df8ac4b67f03a2d94fccd0788" => :el_capitan
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
