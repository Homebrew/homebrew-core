class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.9/poco-1.7.9-all.tar.gz"
  sha256 "55cab0a9d56194966857367eef102c1da02ddc694b8b0cacc60b8d85d7975bbb"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "3702a2e201c341223d142fcc26ffaa52f4d0ce3313a59bb69b235c6e27b2bef5" => :sierra
    sha256 "d18d1274c9fa61fcd6b55a294de09508f7e443247e5e2efc6b6dee28d2ecf42d" => :el_capitan
    sha256 "ef306082aeb0e6b6baba905af69674bb9b6642ffe6e117f88fdbf143a8a28d61" => :yosemite
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
