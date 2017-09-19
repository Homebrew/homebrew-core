class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.9/poco-1.7.9-all.tar.gz"
  sha256 "55cab0a9d56194966857367eef102c1da02ddc694b8b0cacc60b8d85d7975bbb"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "4323784bf532fe4b0d2b5d54a3de4b43232a1522d6ab039ab64bb583bcc0f7b5" => :high_sierra
    sha256 "c80792b3455b57111c2cb007b990d01db8286ac664492c8f42f6db5697129f23" => :sierra
    sha256 "c3a306f68a86e4f3041db21f8754c35ddb5beb9febd5241c97a08719e6b73891" => :el_capitan
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
