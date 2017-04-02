class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.8/poco-1.7.8-all.tar.gz"
  sha256 "4e426b4870a79fb42511f6aeadbb688b4047bdc3c9a21ac31deb364ce49ec69f"
  revision 1

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "1dee35ba8ef2da7de4be8a158af03f39734cb605878e6cd32c20297ddb682b4e" => :sierra
    sha256 "8e28312666a16f39dd68f612fb1f9e357be17bab70424e0f7e5cd35995de099e" => :el_capitan
    sha256 "2863537edc4f16a96a031f9b9742a7c2d6d2a3eb605523d859b0d8be52b55c78" => :yosemite
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
