class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.7.5/poco-1.7.5-all.tar.gz"
  sha256 "74fb9f9810ea200b8ff744d222626ec5c10613f9121f2ab7cd70e0e24cb30f38"
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "a5a491f3c52aba7486b33beb3a3b55347e39a9855bf3e229cf9ed6f80fc053d5" => :sierra
    sha256 "54017a5e9dbce15a06eeb0bf5d83c5f6a3851845f974858bb92d818c1e3ff420" => :el_capitan
    sha256 "50742b5aeb644ebec65abed4f82117f1d4a2a507dc0be236b584caaccba949f6" => :yosemite
    sha256 "f91af3ce0aecd4cdd0abec8a6df6174e063fb802264f255555d24b6d76f800b6" => :mavericks
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
