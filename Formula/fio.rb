class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://git.kernel.dk/cgit/fio/"
  url "https://github.com/axboe/fio/archive/fio-3.5.tar.gz"
  sha256 "595c8ff34a327792abce4399591ec30c733e9a9ad9f633270ceda50632a7cd7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecc70574c62c9bac332e7969a1037b5f81ac5f4df3ebf062a99cbc49906f37b8" => :high_sierra
    sha256 "dd840df5d1af841108b1698bed0c02dceaa5726579f0c1b540107d19bd0e2e39" => :sierra
    sha256 "f3c22e03dc23aa9f4bc3f5b2f752d7889640b9131814ec5203e35ad8cd6c9691" => :el_capitan
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
