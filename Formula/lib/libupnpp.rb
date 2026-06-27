class Libupnpp < Formula
  desc "C++ wrapper for libnpupnp"
  homepage "https://www.lesbonscomptes.com/upmpdcli/libupnpp-refdoc/libupnpp-ctl.html"
  url "https://www.lesbonscomptes.com/upmpdcli/downloads/libupnpp-1.0.4.tar.gz"
  sha256 "4738a19be51c09bd59a26b28e305172e2052c0e970b2fad92320a2d7cf1157c5"
  license "LGPL-2.1-or-later"
  head "https://framagit.org/medoc92/libupnpp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "85c47c5801796e4737a029ab321194f24dd0aa0bbf4bf593eba870a3f4649b8f"
    sha256 cellar: :any, arm64_sequoia: "fabd8de54a9455badfff09e2a871fd6205afc1077846c927667e0286f44acad8"
    sha256 cellar: :any, arm64_sonoma:  "b6738d36760f826f6befd01d9233ff64e34c96b65c7225067892ec54ecf50555"
    sha256 cellar: :any, sonoma:        "e58803076ea50f5046010dc8c4041f7cee6234f12a670f3354556acec8f57b32"
    sha256               arm64_linux:   "cf15fd96a718f69dc4fb2af3370f87e20b851d613ebef1be13d8370c8adf6f4d"
    sha256               x86_64_linux:  "1666386133c38c3b3bcf68b4af57ff5c57b43f5683d3f7767cc4d7aae7ddd05f"
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
