class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.4.tar.bz2"
  sha256 "ec36fb49080f834690c24008328a5ef42d3cf584ef4060f3a35aa4681cb31b74"
  revision 2

  bottle do
    cellar :any
    sha256 "6bac331af0d1516b3f5cd2b27f8b4ae78647f371f3903b9b9f89aad29963ef1f" => :catalina
    sha256 "31f0705e5764462ac4e447966bf295db5655fd5b032ad984538883a2f952d4eb" => :mojave
    sha256 "40aa8fcdecc3af1859fd3fba4bd344b26d8b9746712d6cbc1291a2518451d2fb" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "libusb"

  def install
    mkdir "libftdi-build" do
      system "cmake", "..", "-DPYTHON_BINDINGS=OFF",
                            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
                            *std_cmake_args
      system "make", "install"
      pkgshare.install "../examples"
      (pkgshare/"examples/bin").install Dir["examples/*"] \
                                        - Dir["examples/{CMake*,Makefile,*.cmake}"]
    end
  end

  test do
    system pkgshare/"examples/bin/find_all"
  end
end
