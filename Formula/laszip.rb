class Laszip < Formula
  desc "Lossless LiDAR compression"
  homepage "https://laszip.org/"
  url "https://github.com/LASzip/LASzip/releases/download/3.2.8/laszip-src-3.2.8.tar.gz"
  sha256 "b2dece1ce8a9764981aab43ee49ae9798c86a23a737dc9e982c60dbf510f886e"
  head "https://github.com/LASzip/LASzip.git"

  bottle do
    sha256 "eadf67868a2515fe79d43206d4f2e476a2c252066c07c2c62d3e9368ea532072" => :mojave
    sha256 "8080fc8d257445fc8707d6c51ff7ba1788d09206d05af74a1ba94db26db2f0eb" => :high_sierra
    sha256 "3ab43e3c71a5487a933311be1870ec52072c169012d9e2dbb47b167d0d384204" => :sierra
    sha256 "9307ea47e925d608e89b39ae221181a6ef235d37c7c6e2c02db2a4b230d6f375" => :el_capitan
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
