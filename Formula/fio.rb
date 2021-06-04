class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.27.tar.gz"
  sha256 "4ba3cb1be56521456b80a5b6f5ce81e891e5de1305c45ef17e8182bebe4545b4"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c280b2552998b2149c68b50f979351d8c5d5cdd8ed958931737274a944b70cf9"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb9050168d21fefdc45f840013449816b36081531f378bad0476d7bfc98aead2"
    sha256 cellar: :any_skip_relocation, catalina:      "67b18e9eaacd69787de1eaa32d978a11f507e47178121e3e1ca7a625240a4fdc"
    sha256 cellar: :any_skip_relocation, mojave:        "c438ba9327ba63b5034b0a0e4004b3a97480fdd8568c6fcb8fe6f6bd7446421c"
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
