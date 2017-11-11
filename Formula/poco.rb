class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.8.0/poco-1.8.0-all.tar.gz"
  sha256 "c0f2ca3fbbb701bfaa55796d7b6ef35127cb27d4333c2e75074c601276371fc0"

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
