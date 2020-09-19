class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.23.tar.gz"
  sha256 "a35e6c2eb69cde26d771175cb9a46719c964c7bbb700328da8649ab22a6b624c"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "252dd7cba1c767568b9ecb13fbbd891e1ffe47f590ed126cfea8214ff20333f5" => :catalina
    sha256 "2b4b3372f9ad040eb974ba38ecdde11c08b0328fae71d785e5d0b88c77ecffc3" => :mojave
    sha256 "89e47c70a1cca2e1acf29b97720da6b968348ea93a5e417fdca7ad86d670114d" => :high_sierra
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
