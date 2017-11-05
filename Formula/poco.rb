class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.9/poco-1.7.9p1-all.tar.gz"
  sha256 "76f698d3e537879664f56a3dfde3a88e88f06c13b6474dd6a0ee6ad7f6ab4e4a"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a660300244ce2567e1abeebf18db634f517692dbb2b2d4765074050fb522539a" => :high_sierra
    sha256 "995f536da783631be5266076fd0caae50657d13f682e089102e56d747c6f09ca" => :sierra
    sha256 "e8b196801ed82c2190847c5a7bcd9af79e1adbaabcd2841fc3645a7412df364e" => :el_capitan
  end

  option "with-static", "Build static libraries (instead of shared)"

  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DENABLE_DATA_MYSQL=OFF" << "-DENABLE_DATA_ODBC=OFF"
    args << "-DPOCO_STATIC=ON" if build.with? "static"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
