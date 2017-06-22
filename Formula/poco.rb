class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.8/poco-1.7.8p1-all.tar.gz"
  sha256 "9d6ddc97b7b6f8c488dd46f421daf4cc8c1b56e33824d6ae198bf5fd7f1dbe03"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "8b16e527afed4d5d3329b71f7d96867d262e06c9ae592c1a8ddf179534e9dd33" => :sierra
    sha256 "780f3a121a69fe124cae38c21a54935a63314a1f35d4ce722344fb0b3ad2bd64" => :el_capitan
    sha256 "d1bfb87b14dd1d12fab0be523c27874edc16a0c39d301e28ac23ca4035da746d" => :yosemite
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
