class Laszip < Formula
  desc "Lossless LiDAR compression"
  homepage "https://www.laszip.org/"
  url "https://github.com/LASzip/LASzip/releases/download/3.1.1/laszip-src-3.1.1.tar.gz"
  sha256 "53307e39072318b0175787cf0ed445de12efe0d6b4ccae66829a9a475f3aca19"
  head "https://github.com/LASzip/LASzip.git"

  bottle do
    sha256 "6266d1b03ead773ee15dcdfecb812ed1fbd863727e627a1cc1aeff1337b7e213" => :high_sierra
    sha256 "5636b7aa65aaea72cfe7d6d84e93f2387c5cb88bf470b59a246746f20f0fb43d" => :sierra
    sha256 "842a38438ad8c3ce33acea6bc9528a4ef7a4b7fc5181455a8fc85f9e4ffb00fc" => :el_capitan
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
