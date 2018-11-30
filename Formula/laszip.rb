class Laszip < Formula
  desc "Lossless LiDAR compression"
  homepage "https://laszip.org/"
  url "https://github.com/LASzip/LASzip/releases/download/3.2.8/laszip-src-3.2.8.tar.gz"
  sha256 "b2dece1ce8a9764981aab43ee49ae9798c86a23a737dc9e982c60dbf510f886e"
  head "https://github.com/LASzip/LASzip.git"

  bottle do
    sha256 "fad706b5e3c6a0d7cc414d7add0d9397da97c18c05e1852f8fb5fea7e432691d" => :mojave
    sha256 "4e0eede32c34aa0298318235e79cdae555fbb901eaaae91ddd813f33a9b025f3" => :high_sierra
    sha256 "d840cd999b4de36df15ffae98d21397172acbfd9c3d1796762eec304a6a94cbd" => :sierra
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
