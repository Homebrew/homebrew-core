class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.5.tar.bz2"
  sha256 "7c7091e9c86196148bd41177b4590dccb1510bfe6cea5bf7407ff194482eb049"

  livecheck do
    url "https://www.intra2net.com/en/developer/libftdi/download.php"
    regex(/href=.*?libftdi1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "17e8dfd27de8a962633117a3ec780dbbe416206bd66b315ead3a5e5ed5caee27" => :big_sur
    sha256 "a139a5e28a0f0e7a548d5cd8c0c6ae3f53216c722c29aa585f0bb7d342acafbe" => :arm64_big_sur
    sha256 "2ac29fc67dacd7c6e2c73e93114019d0df07aaeac7678c74402289d91d128d00" => :catalina
    sha256 "e267d6e573aad2f1372f5731bf2be30177d5b4feb6c30b0ac96b8933f545983a" => :mojave
    sha256 "5610431987b6b03db32ebed2c24b5007ffad77343cee35bfd23ed93470539846" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "confuse"
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
