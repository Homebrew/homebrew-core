class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.7.3/poco-1.7.3-all.tar.gz"
  sha256 "0df00e6b7e915f5a2a4b3ec3035a4dc4fc5ed328b5c3648cf8bdbd42b75aa2d5"
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "fb77d69a952461f1dc8b97a5a715335fac8f9dcf96ce3b63147c20aab14e020f" => :el_capitan
    sha256 "9028068c6c3578af781a9acb8311e57aa86b7b2b1c184a616d2c61fee21e56e1" => :yosemite
    sha256 "a799fd928197ffbd7b2b40646c7e392be149480bba5e1dd9f38d9c7837074e9b" => :mavericks
  end

  option :cxx11
  option :universal
  option "with-static", "Build static libraries (instead of shared)"

  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args
    args << "-DENABLE_DATA_MYSQL=OFF" << "-DENABLE_DATA_ODBC=OFF"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    args << "-DPOCO_STATIC=ON" if build.with? "static"

    mkdir "macbuild" do
      system "cmake", buildpath, *args
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
