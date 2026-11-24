class Libupnpp < Formula
  desc "C++ wrapper for libnpupnp"
  homepage "https://www.lesbonscomptes.com/upmpdcli/libupnpp-refdoc/libupnpp-ctl.html"
  url "https://www.lesbonscomptes.com/upmpdcli/downloads/libupnpp-1.0.5.tar.gz"
  sha256 "f83da1bfde4823bb079ce228a2c9abd695274ae572758dbb02159184db150dd0"
  license "LGPL-2.1-or-later"
  head "https://framagit.org/medoc92/libupnpp.git", branch: "master"

  livecheck do
    url "https://www.lesbonscomptes.com/upmpdcli/downloads/"
    regex(/href=.*?libupnpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "f7109191a90d2e4d7a5aedc503aeef2e35aa2e8817e41611cddb54638be6468d"
    sha256 cellar: :any, arm64_golden_gate: "ccb0137840f720ce1f1d6e29ce9981571f4c61e75f1d9f3bebc01b972affe82b"
    sha256 cellar: :any, arm64_tahoe:       "205773139cbc90a3aabda079629cbf6cb85e387a245f2455be3ac4efa52b1296"
    sha256 cellar: :any, arm64_sequoia:     "a1a0c5288e77c5d3e125ece91bb18e0fa614c5d32cb2b7775882fba92e241f49"
    sha256 cellar: :any, arm64_linux:       "e43809b0d36770ef8106fb9ee93f6dda4940a5c8e459fef87abf33f76f3137f1"
    sha256 cellar: :any, x86_64_linux:      "1fdd2de0705be91b5ad02f38e957f1ceaa37e226a04a26292e406039c4f1d9cf"
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
