class Libupnpp < Formula
  desc "C++ wrapper for libnpupnp"
  homepage "https://www.lesbonscomptes.com/upmpdcli/libupnpp-refdoc/libupnpp-ctl.html"
  url "https://www.lesbonscomptes.com/upmpdcli/downloads/libupnpp-1.0.3.tar.gz"
  sha256 "d3b201619a84837279dc46eeb7ccaaa7960d4372db11b43cf2b143b5d9bd322e"
  license "LGPL-2.1-or-later"
  head "https://framagit.org/medoc92/libupnpp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fe7ac3cf9bb208dd79f7b71de0e47c0c536604b6878280d281ebc0d0ab92fc5d"
    sha256 cellar: :any, arm64_sequoia: "3af04395d956b3c754c5f95c0c7ae63e2177cc9ff9113b16eaff4b2536613046"
    sha256 cellar: :any, arm64_sonoma:  "7d4684c90b54ef7c2df0c49c030adb726580aa8d833e92e11a9e8c2e9c5fda80"
    sha256 cellar: :any, sonoma:        "077d55290db1c66da57b9bb6e46ae09eeb244a718927844609d0265b49257c3d"
    sha256               arm64_linux:   "3ea1d55a675da80f8b4fe995981c23e99c0dc4ed0f011b24558096c58c6e3c90"
    sha256               x86_64_linux:  "27ff2c93ece22ce524c998da3bfd86666979944821fee422b8973ddaa67b2482"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libnpupnp"

  uses_from_macos "curl"
  uses_from_macos "expat"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <libupnpp/log.hxx>
      #include <libupnpp/upnpplib.hxx>

      int main(void) {
        Logger::getTheLog("")->setLogLevel(Logger::LLERR);
        UPnPP::LibUPnP *mylib = UPnPP::LibUPnP::getLibUPnP();
        if (!mylib) {
          std::cerr << "Can't get LibUPnP" << std::endl;
          return 1;
        }
        if (!mylib->ok()) {
          std::cerr << "Lib init failed: " << mylib->errAsString("main", mylib->getInitError()) << std::endl;
          return 1;
        }
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-lupnpp"
    system "./test"
  end
end
