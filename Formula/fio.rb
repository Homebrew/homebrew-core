class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-2.20.tar.gz"
  sha256 "eb51fbad161929f1bcd6c1d0d09d2c7543651f834aec860ba5def9bc52dcc3ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6829998a0d425891d014e7bc4771b03fd8f9295bb38bf948e24a64c51d495c6" => :sierra
    sha256 "25685e90b5db416ffc4d0291ce4330f4396735b44d2395a4a58ecd9acdb40943" => :el_capitan
    sha256 "8ed13c81927adb22335e0d6edc534790e1ebae3c0b282ab559ccfc7f80108e86" => :yosemite
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
