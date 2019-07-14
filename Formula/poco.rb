class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.9.2/poco-1.9.2-all.tar.gz"
  sha256 "6dfffb805741d9fe8ca1d0aa4cbeff571585e6f7ac0bb84ebeff50f40def6b4a"
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8fcf6c4bfd4bda264b87c4d3ad4813d7c44adc486c2a83d1d3a769d8a17679ba" => :mojave
    sha256 "b620f2bbd0326a84c6acc7b0bf1765e77198cc690d1141d6ec93ed244ae9886c" => :high_sierra
    sha256 "a2e2b25aa10903f7976fae5d647238c74206f22d58bf916f6205d332a54cd64d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_DATA_MYSQL=OFF",
                            "-DENABLE_DATA_ODBC=OFF"
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
