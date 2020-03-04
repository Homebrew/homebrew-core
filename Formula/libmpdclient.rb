class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.18.tar.xz"
  sha256 "4cb01e1f567e0169aca94875fb6e1200e7f5ce35b63a4df768ec1591fb1081fa"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    cellar :any
    sha256 "f2b24acc930ccf6f52580122187b1e0b6069e9407674e4a9f795740576f3478b" => :catalina
    sha256 "bf5948d2521dc3c54a31740765162ef9f4043415b01a1377002597c54bb68324" => :mojave
    sha256 "4bb5a9d58a7dd3cdb13320ff6a650ce979446e3fa61cabb2aa4954c3ef17e62a" => :high_sierra
  end

  depends_on "doxygen" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "--prefix=#{prefix}", ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mpd/client.h>
      int main() {
        mpd_connection_new(NULL, 0, 30000);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmpdclient", "-o", "test"
    system "./test"
  end
end
