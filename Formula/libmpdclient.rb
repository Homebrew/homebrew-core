class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.19.tar.xz"
  sha256 "158aad4c2278ab08e76a3f2b0166c99b39fae00ee17231bd225c5a36e977a189"
  license "BSD-3-Clause"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    cellar :any
    sha256 "380c12b70376c6317224b66a5a4257676fe1cc097b2792c2f2305c1ead01c5ea" => :catalina
    sha256 "ed880f1893822ccb69b3ea105482ca1184d764ffb8ccb8511821ad108ccf8fbe" => :mojave
    sha256 "35c9b89256c00aae2870c54f47e3abe41c9659a2a5de111d313534b103fe05d3" => :high_sierra
  end

  depends_on "doxygen" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build

  def install
    system "meson", *std_meson_args, ".", "output"
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
