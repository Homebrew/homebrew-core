class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.16.tar.xz"
  sha256 "fa6bdab67c0e0490302b38f00c27b4959735c3ec8aef7a88327adb1407654464"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    cellar :any
    sha256 "c3d3c81a4885afef4b0fa613859bbaadf14e755921637c27095192bceba7b57d" => :mojave
    sha256 "a4b68fd2d553aad650263ddf646fc8a402df86f1341f4febee85a69e46916a2f" => :high_sierra
    sha256 "4e1b4802e6fa4e958d78c03d3cc14f33fece909975a9c40fa83946c5fd2a30b1" => :sierra
    sha256 "573291d299ec6ee87a40cd79374cd7697e784230774852cf2bab9e20fcc83b54" => :el_capitan
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
