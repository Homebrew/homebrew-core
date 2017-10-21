class Libvorbis < Formula
  desc "Vorbis General Audio Compression Codec"
  homepage "http://vorbis.com/"
  url "https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.xz"
  sha256 "54f94a9527ff0a88477be0a71c0bab09a4c3febe0ed878b24824906cd4b0e1d1"
  revision 1

  bottle do
    cellar :any
    sha256 "df0263fb6082aeeb082de5f2f10282087925b4dc3d0ca2433813c683f1b1aec1" => :high_sierra
    sha256 "bb0732d6af0d2a9cdf1004ebbf48da1758cfac1fbb65cfbb91d0bbf936d7d596" => :sierra
    sha256 "8a0b39934d086a5be7d7daede5807bd99baf0d9f5ce5dc860abcec3427c32a44" => :el_capitan
    sha256 "e3892e6523bc1411f5b164b7c64f392897c7735894aa654688cd904d4cfaa3b2" => :yosemite
  end

  head do
    url "https://git.xiph.org/vorbis.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"

  resource("oggfile") do
    url "https://upload.wikimedia.org/wikipedia/commons/c/c8/Example.ogg"
    sha256 "379071af4fa77bc7dacf892ad81d3f92040a628367d34a451a2cdcc997ef27b0"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <assert.h>
      #include "vorbis/vorbisfile.h"
      int main (void) {
        OggVorbis_File vf;
        assert (ov_open_callbacks (stdin, &vf, NULL, 0, OV_CALLBACKS_NOCLOSE) >= 0);
        vorbis_info *vi = ov_info (&vf, -1);
        printf("Bitstream is %d channel, %ldHz\\n", vi->channels, vi->rate);
        printf("Encoded by: %s\\n", ov_comment(&vf,-1)->vendor);
        return 0;
      }
    EOS
    testpath.install resource("oggfile")
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lvorbisfile",
                   "-o", "test"
    assert_match "2 channel, 44100Hz\nEncoded by: Xiph.Org libVorbis",
                 shell_output("./test < Example.ogg")
  end
end
