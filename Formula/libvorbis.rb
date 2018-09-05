class Libvorbis < Formula
  desc "Vorbis General Audio Compression Codec"
  homepage "https://xiph.org/vorbis/"
  url "https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.xz"
  sha256 "af00bb5a784e7c9e69f56823de4637c350643deedaf333d0fa86ecdba6fcb415"

  bottle do
    cellar :any
    sha256 "ac35ee835666c32cd678636e1d19899dfef55191bcc776eeddedcd5ad19eac03" => :mojave
    sha256 "a9ec94abce8d34210ce323d2398ae689c330e7f069ecde0d4c40ef3b8259f6ba" => :high_sierra
    sha256 "b0912f4af1e8e229b1cf80cceb9a2ad4357e77206691afd628973f360ad8af1d" => :sierra
    sha256 "a888a452d5089281a05607449f10df9d8d6eb09c8effb93470f0f4f06349df8b" => :el_capitan
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
