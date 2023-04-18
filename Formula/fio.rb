class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.34.tar.gz"
  sha256 "42ea28c78d269c4cc111b7516213f4d4b32986797a710b0ff364232cc7a3a0b7"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "864a81ae91d73c2401786d1f5300e2aa3b4bf3640a660a7b0700f37cc7c8c79e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9467ab670d77369915ac7741f476c0182d173b14941875dce62f38aa30c2d145"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23bb4c3dd5c3d9faa17aa08359f1ad190a63d6791dc06254adfaa090c5c74e79"
    sha256 cellar: :any_skip_relocation, ventura:        "010ccd09ffe4a7ea26080d9f8ed712a3e5d6587140eea330dd1d60860aeb54da"
    sha256 cellar: :any_skip_relocation, monterey:       "88e866b04e6288a9e76bc80c39ba8baa3acf27b41beff4c3aff0b39acd35907d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e2b45ed7c4a416304e17f0b66858611008dd715f0dee8a7a9c9434c43c1b8d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8997e8315386aa1195bc5f9753a9bd53a13e92034595850282962876c36fd8d2"
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
