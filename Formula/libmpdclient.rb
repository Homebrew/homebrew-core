class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.16.tar.xz"
  sha256 "fa6bdab67c0e0490302b38f00c27b4959735c3ec8aef7a88327adb1407654464"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    cellar :any
    sha256 "eced9203dc302b1d0c21545323d3ee359b9f27e1479839ef152e68049113e564" => :mojave
    sha256 "6cfadc0468d601fbb4557916fdbd4de7d9c02bbcfaa492c2af04ad4e3ddbf9ae" => :high_sierra
    sha256 "4eb9e5b366c478aebb1692b21a63747d3ef6a2dee9cd61c036a39c67a2640274" => :sierra
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
