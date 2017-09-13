class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/v2.2.1.tar.gz"
  sha256 "ae27cdbcd6a2f935baa78e4f21f675649271634c092b1be01469440495609d0e"

  bottle do
    cellar :any
    sha256 "519562ecebe66cf89803786d0b0ba9ac02cfa2376c822c8726fa274c1e380d0a" => :sierra
    sha256 "9e9c1a067b324ccd372ac00cd0ac00545415cb4407ea90b15c181cbfb67a4260" => :el_capitan
    sha256 "5e6fcff184b2d6caf333a74cb24222da11bc1721eb6ab12a31bda7802cf8dfd9" => :yosemite
  end

  option "with-debug", "Build debug version"
  option "with-static", "Build gflags as a static (instead of shared) library."

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    if build.with? "static"
      args << "-DBUILD_SHARED_LIBS=OFF"
    else
      args << "-DBUILD_SHARED_LIBS=ON"
    end
    mkdir "buildroot" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
