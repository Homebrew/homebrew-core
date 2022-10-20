class Libvorbis < Formula
  desc "Vorbis General Audio Compression Codec"
  homepage "https://xiph.org/vorbis/"
  url "https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.xz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.7.tar.xz"
  sha256 "b33cc4934322bcbf6efcbacf49e3ca01aadbea4114ec9589d1b1e9d20f72954b"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/?C=M&O=D"
    regex(/href=.*?libvorbis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "521810a7d5d4d0779cfc22a7d8ba37bb452fea06a3ab8205d882961d1eeb8ff7"
    sha256 cellar: :any,                 arm64_big_sur:  "07ab1118fc6d389a8b0506d0b74a3cfc12026a837c8f2609b2133318c8818c81"
    sha256 cellar: :any,                 monterey:       "ce6cfb42216b79203bf86458b0f22cc42c0aeb5e1b1c0ab56e604b83ef374553"
    sha256 cellar: :any,                 big_sur:        "05e639c274f52924cbf31fb4337888ab51554a66597486aeed8e5942d267c586"
    sha256 cellar: :any,                 catalina:       "432eb21045d9dfac3ef879648d845d894cc828862f5498448fe98c0141ef5cd0"
    sha256 cellar: :any,                 mojave:         "59509a351e88352f01512b54cc5cb849c2551623f7d6dcd6679d38b5e96032ed"
    sha256 cellar: :any,                 high_sierra:    "3e6609520d0ffd7179f721c23c1291f2735b70384d56d1c1dd10185ae355c4b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c205523df9d4dd5f8ee71b26018419b9cf5bbca73c64eec36f5cbe5f2db6bbbd"
  end

  head do
    url "https://gitlab.xiph.org/xiph/vorbis.git"

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
