class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.17.tar.gz"
  sha256 "d0c3bfe502f5c70e68fb478c537dc7c6539aed8bf0f898d84e6223e61fd2c65f"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d0ecb2dae7e1cbf3e4c3cdc67614737fb25b3fdc860a7d66123be7abf9e21e0" => :catalina
    sha256 "f1ea4e110f71aeb9c4ebe19b268e4d4b2f708913a8157cfe04108efc36d4f58d" => :mojave
    sha256 "1ce5d5d891a244f2f2696667e78e6fe35cfa08071bd66dc76a43f969aa1af94b" => :high_sierra
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
