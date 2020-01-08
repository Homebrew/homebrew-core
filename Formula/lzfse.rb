class Lzfse < Formula
  desc "Apple LZFSE compression library and command-line tool"
  homepage "https://github.com/lzfse/lzfse"
  url "https://github.com/lzfse/lzfse/archive/lzfse-1.0.tar.gz"
  sha256 "cf85f373f09e9177c0b21dbfbb427efaedc02d035d2aade65eb58a3cbf9ad267"

  bottle do
    cellar :any
    sha256 "bf5a9fba1911206046cb4698e9b23ac23f247bcd1c47cdd779fa7a786c40aa27" => :catalina
    sha256 "2f42a21db8de9f71535a0a9b7ca084f1a0e89174cbda174915f5da2e1ec5d3d2" => :mojave
    sha256 "e2a28bc48a8d90dd26cf2fe92d9186cbe0f19c8a58a5d15c8591826cd047b43b" => :high_sierra
    sha256 "2da23959f27fe8a141b2967a591052c6ec081224b7b3c9c65c4a854faba77456" => :sierra
    sha256 "4fcadd0779483cf14e95f7566002af22e9b488585c37fba1b5e75f715b930c01" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    File.open("original", "wb") do |f|
      f.write(Random.new.bytes(0xFFFF))
    end

    system "#{bin}/lzfse", "-encode", "-i", "original", "-o", "encoded"
    system "#{bin}/lzfse", "-decode", "-i", "encoded", "-o", "decoded"

    assert compare_file("original", "decoded")
  end
end
