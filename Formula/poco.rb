class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.8/poco-1.7.8-all.tar.gz"
  sha256 "4e426b4870a79fb42511f6aeadbb688b4047bdc3c9a21ac31deb364ce49ec69f"
  revision 1

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "43f5f683dc6368bd5565f49088e6853e7a5902f3526ef38d8fd25eca6d348c8b" => :sierra
    sha256 "82b3b4488afe1d58452cb4451eb9e3f91128635687708ec8ab23158e43a5a6a2" => :el_capitan
    sha256 "8d62a92a35cef00ac6eb7fdd6fded8f4ec045cae5b002c542b34b0aab14e025c" => :yosemite
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
