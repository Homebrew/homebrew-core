class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.8.1/poco-1.8.1-all.tar.gz"
  sha256 "881e8dddb62c2b38daf46f56b946d6ac173a129ad972210dd39b9401e644e4dd"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "5d9a1599bd02750d1249ffd799c84c83e32905e7bcd40b9b5cda41e08170156a" => :high_sierra
    sha256 "b1669c4b90ab15d760b48b9cbe8b66dc2a8c225caa43b7a5332aeeb121b0c510" => :sierra
    sha256 "3e15e7f5ac81655aa145c9423f079cedf36352a063c033233533ea86104db1bb" => :el_capitan
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
