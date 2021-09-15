class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.6.2/liblcf-0.6.2.tar.xz"
  sha256 "c48b4f29ee0c115339a6886fc435b54f17799c97ae134432201e994b1d3e0d34"
  license "MIT"
  revision 3
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ac4128d58f95e92dbb494d02fd3a9c75f41f024c37bf5225e5b4dc551bbd207b"
    sha256 cellar: :any,                 big_sur:       "4324dce9a80a86cbd12fa12f73719cf5a9710f42d7b5d71e29d87fd4179f685c"
    sha256 cellar: :any,                 catalina:      "928d1095b1b008b0416636501459f0ff7bd22d8b69eef75ea9e4c151dafbe703"
    sha256 cellar: :any,                 mojave:        "0391e77bd5cefbdfdda6ba603a01e8c206b21acb662649f2e602d66e6f9401ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b0eea36554d5c51a76a48fbb100a302a0986fc38d8cee84df55864c2e57775"
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"

  uses_from_macos "expat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "lsd_reader.h"
      #include <cassert>

      int main() {
        std::time_t const current = std::time(NULL);
        assert(current == LSD_Reader::ToUnixTimestamp(LSD_Reader::ToTDateTime(current)));
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/liblcf", "-L#{lib}", "-llcf", "-std=c++11", \
      "-o", "test"
    system "./test"
  end
end
