class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://git.kernel.dk/cgit/fio/"
  url "https://github.com/axboe/fio/archive/fio-3.5.tar.gz"
  sha256 "595c8ff34a327792abce4399591ec30c733e9a9ad9f633270ceda50632a7cd7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c22570d3fd4a89b6a01df4b5dc361212846925ce0c13092e3f94e8fff1e6b69c" => :high_sierra
    sha256 "c7cedc3e313d9d4f03196ae2d049665f9d1636b1824cd9debcd3acfcc796e5bb" => :sierra
    sha256 "0255c72ea14fe44625c23c8ecd3cfc2c7b7fb1ae1e5cd04418048e9fd1cfabe9" => :el_capitan
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
