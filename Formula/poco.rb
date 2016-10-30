class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.6/poco-1.7.6-all.tar.gz"
  sha256 "e32825f8cd7a0dc907b7b22c8fb3df33442619cc21819e557134e4e2f5cc4e2d"
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "069878455ba2f13ff122b60f48f0b58b05dcfe95e66295b05da5204e6686609d" => :sierra
    sha256 "4d7332c458dbfa0d774ea0e6782f9f01c46edc53122d1626de7e5d870f3317cb" => :el_capitan
    sha256 "05f906e0cd61e57f95c3b019b55a826a78610ba53e11270d95bf0dfbd3e1b64c" => :yosemite
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
      %w[
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
