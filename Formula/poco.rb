class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.8/poco-1.7.8p3-all.tar.gz"
  sha256 "8eb1a77dc7ad76757528884358c16b22c458f1fde82e17851cbd2e2338b4e6e4"

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
