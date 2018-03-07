class Hexer < Formula
  desc "Hexbin density and boundary generation"
  homepage "https://github.com/hobu/hexer"
  url "https://github.com/hobu/hexer/archive/1.4.0.tar.gz"
  sha256 "886134fcdd75da2c50aa48624de19f5ae09231d5290812ec05f09f50319242cb"
  depends_on "cmake" => :build
  depends_on "gdal"
  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
  test do
    system bin/"curse", "-c", "hex", "-i", "fake_file"
  end
end
