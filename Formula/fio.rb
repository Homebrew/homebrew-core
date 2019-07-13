class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.15.tar.gz"
  sha256 "c0c0e40e770abcd5ab013af4bd8b16dfa83645145871063939db2a14270e2545"

  bottle do
    cellar :any_skip_relocation
    sha256 "d35ec8157a120eb36b9c56bea24a0508f2b23da64638de724d973769f3a05906" => :mojave
    sha256 "285d58649e0199555327bf88c8769c12328a4658f12237f318f890f825d8c1de" => :high_sierra
    sha256 "8f881084e2d7ec7cc844512670907e60f92cf3a8248ef14f15c2b808ee021589" => :sierra
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
