class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.6.2/liblcf-0.6.2.tar.xz"
  sha256 "c48b4f29ee0c115339a6886fc435b54f17799c97ae134432201e994b1d3e0d34"
  license "MIT"
  revision 2
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9677e5b38485773f11aedbc5ead4361fcb8e4e7afb6c2f4f06ea420511f4fcb9"
    sha256 cellar: :any, big_sur:       "1c195cf45d0bbcbff8684a4d237708098c953d999a7cb0abedb26e059e9917a6"
    sha256 cellar: :any, catalina:      "a0381102d780bc23458421331a1fe578a471616b1d2c30f8170423f0f9b30cbe"
    sha256 cellar: :any, mojave:        "afb3d7350397947acbdd9b154303162ce0230f42c0a46f9d438c75966b0d40bc"
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
