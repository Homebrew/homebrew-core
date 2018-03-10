class Lzfse < Formula
  desc "Apple LZFSE compression library and command-line tool"
  homepage "https://github.com/lzfse/lzfse"
  url "https://github.com/lzfse/lzfse/archive/lzfse-1.0.tar.gz"
  sha256 "cf85f373f09e9177c0b21dbfbb427efaedc02d035d2aade65eb58a3cbf9ad267"

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
