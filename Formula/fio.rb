class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.13.tar.gz"
  sha256 "24d7917e830ea6eeebe2a90f4d374b8317c45aa0df7c4fc0b420be3fa6edf1f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "85f5b161461e6379af7cbc8b08f549cb56af1b073437165975c3c1cd754027ca" => :mojave
    sha256 "c4c5d539d96b00a5cafaee423102fa45b8761d9aa128656ff82ae6ba95f680b6" => :high_sierra
    sha256 "34754b4ae14c129cb9483f038d6cc885a2ea0701ef6eb771bcf6b430afafe606" => :sierra
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
