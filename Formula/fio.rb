class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.12.tar.gz"
  sha256 "c9fb079e24bb02413b106a80a20e43b2166ba8681e371a5fb9002b8c9d79bd36"

  bottle do
    cellar :any_skip_relocation
    sha256 "39a042775bc8e7f84c18cf714080ca0b70768625f41dc085a6ceb1c116a2875e" => :mojave
    sha256 "0fddb60bfc65a89bce2b7f9a0226e8f792302c29bd3c18684e28a943c13bd6af" => :high_sierra
    sha256 "528b4c5cde0ef580ad4dc192b54588c9c5302f48d4ef84bf7c3063a2eb50761c" => :sierra
    sha256 "2474d07db0d530e110500dbc7d64e7b43cbb527b9c0d42b439b551fe6779b3bf" => :el_capitan
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
