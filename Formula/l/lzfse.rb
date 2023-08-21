class Lzfse < Formula
  desc "Apple LZFSE compression library and command-line tool"
  homepage "https://github.com/lzfse/lzfse"
  url "https://github.com/lzfse/lzfse/archive/lzfse-1.0.tar.gz"
  sha256 "cf85f373f09e9177c0b21dbfbb427efaedc02d035d2aade65eb58a3cbf9ad267"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e6932c59d8f1f9462445d06f243af20c1c2a09c6eaaea3c5cc4ec8efb9466ce1"
    sha256 cellar: :any,                 arm64_monterey: "33351619d36c622d4fbd63cd02f475e4f88da26a46351f62466003536f417cb4"
    sha256 cellar: :any,                 arm64_big_sur:  "99a83dce436e46d4d13a9825155abec9105857b23037a555bc399728c925d5c7"
    sha256 cellar: :any,                 ventura:        "907f55be17f387f646e1bf8e95b60cd64534ea8b39210bcdf29aa9fcde331a61"
    sha256 cellar: :any,                 monterey:       "11e09e89227d27ecba48954e45077fcc0d0b4c5f6e55e8540be252ffb3050770"
    sha256 cellar: :any,                 big_sur:        "77feda1fad9da3e2e867fb1a7ca2c56b9beb300cf9d5fa6c383c516f4613c34e"
    sha256 cellar: :any,                 catalina:       "bf5a9fba1911206046cb4698e9b23ac23f247bcd1c47cdd779fa7a786c40aa27"
    sha256 cellar: :any,                 mojave:         "2f42a21db8de9f71535a0a9b7ca084f1a0e89174cbda174915f5da2e1ec5d3d2"
    sha256 cellar: :any,                 high_sierra:    "e2a28bc48a8d90dd26cf2fe92d9186cbe0f19c8a58a5d15c8591826cd047b43b"
    sha256 cellar: :any,                 sierra:         "2da23959f27fe8a141b2967a591052c6ec081224b7b3c9c65c4a854faba77456"
    sha256 cellar: :any,                 el_capitan:     "4fcadd0779483cf14e95f7566002af22e9b488585c37fba1b5e75f715b930c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f5733f570ee2f8d436c66beed32cbece59522b57653fba497c9dda82bd0aed"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    File.binwrite("original", Random.new.bytes(0xFFFF))

    system "#{bin}/lzfse", "-encode", "-i", "original", "-o", "encoded"
    system "#{bin}/lzfse", "-decode", "-i", "encoded", "-o", "decoded"

    assert compare_file("original", "decoded")
  end
end
