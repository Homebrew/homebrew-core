class Laszip < Formula
  desc "Lossless LiDAR compression"
  homepage "https://laszip.org/"
  url "https://github.com/LASzip/LASzip/releases/download/3.2.9/laszip-src-3.2.9.tar.gz"
  sha256 "a1cc9ea5adfcad43b9c8afbaff20bcd573a85c90dd83d5c8e17e4ff8d8d4548e"
  head "https://github.com/LASzip/LASzip.git"

  bottle do
    sha256 "d57ead739b110077881947019ad017ca14c851d460d4a0e0055f5f7a10befe4b" => :mojave
    sha256 "84f82e70332ca9166871f1a731cb5f17dc80e42f07987f33e690b013c5d7febd" => :high_sierra
    sha256 "450e33770ba3271b4bed03371a2461fa08c738567db34c5da45198bb2079eb45" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "example"
  end

  test do
    system ENV.cxx, pkgshare/"example/laszipdllexample.cpp", "-L#{lib}",
                    "-llaszip", "-llaszip_api", "-Wno-format", "-o", "test"
    assert_match "LASzip DLL", shell_output("./test -h 2>&1", 1)
  end
end
