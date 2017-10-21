class Laszip < Formula
  desc "Lossless LiDAR compression"
  homepage "https://www.laszip.org/"
  url "https://github.com/LASzip/LASzip/releases/download/3.1.1/laszip-src-3.1.1.tar.gz"
  sha256 "53307e39072318b0175787cf0ed445de12efe0d6b4ccae66829a9a475f3aca19"
  head "https://github.com/LASzip/LASzip.git"

  bottle do
    sha256 "c99dc1884cf70eae67cc22c2e7c1c4a981027f39db33c98dc7e548321ce5469b" => :high_sierra
    sha256 "9262196c5ff19095f656aa9884a997d1d57b1bcf3d01baca5759963d7770fc2a" => :sierra
    sha256 "47d656195a3b4e8fb0f675b8bd0ee6933b4b3c3aca2c17e9db271a00c8fe9383" => :el_capitan
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
