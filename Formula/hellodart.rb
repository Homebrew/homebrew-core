class Hellodart < Formula
  desc "HelloDart"
  homepage "https://www.example.com"
  url "https://github.com/SainathChallagundla/helloDart/archive/v0.0.1.tar.gz"
  version "0.0.1-start"
  sha256 "28531fce0cd32d3358d683c727d76536de2c0a7c968c19843343fdb5da1c49d4"
  license "MIT"
  depends_on "cmake" => :build
  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "cmake", ".", *std_cmake_args
  end
  test do
     `test do`
  end
end
