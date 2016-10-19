class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.6/poco-1.7.6-all.tar.gz"
  sha256 "e32825f8cd7a0dc907b7b22c8fb3df33442619cc21819e557134e4e2f5cc4e2d"
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

    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      %W[
        Foundation/include/Poco/Clock.h
        Foundation/src/Clock.cpp
        Foundation/src/Event_POSIX.cpp
        Foundation/src/Semaphore_POSIX.cpp
        Foundation/src/Mutex_POSIX.cpp
        Foundation/src/Timestamp.cpp
      ].each do |f|
        inreplace f do |s|
          s.gsub! "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH", false
          s.gsub! "CLOCK_REALTIME", "UNDEFINED_GIBBERISH2", false
        end
      end
    end

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
