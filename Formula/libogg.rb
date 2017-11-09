class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  url "https://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.gz"
  sha256 "c2e8a485110b97550f453226ec644ebac6cb29d1caef2902c007edab4308d985"

  bottle do
    cellar :any
    sha256 "1b3faf0793a08736aa1baca0a64aeba93f9d8692472eadfbcca264c9a7308538" => :high_sierra
    sha256 "fedf2c7b4aa2c5051851f47a2131a4f1802791ed3c948446442277ecbabcf32c" => :sierra
    sha256 "67653400da7efbb94fd400c8b90124977d80280dd04ef6771dbe2d8fd2d5aec4" => :el_capitan
  end

  head do
    url "https://git.xiph.org/ogg.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  resource("oggfile") do
    url "https://upload.wikimedia.org/wikipedia/commons/c/c8/Example.ogg"
    sha256 "379071af4fa77bc7dacf892ad81d3f92040a628367d34a451a2cdcc997ef27b0"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ogg/ogg.h>
      #include <stdio.h>

      int main (void) {
        ogg_sync_state oy;
        ogg_stream_state os;
        ogg_page og;
        ogg_packet op;
        char *buffer;
        int bytes;

        ogg_sync_init (&oy);
        buffer = ogg_sync_buffer (&oy, 4096);
        bytes = fread(buffer, 1, 4096, stdin);
        ogg_sync_wrote (&oy, bytes);
        if (ogg_sync_pageout (&oy, &og) != 1)
          return 1;
        ogg_stream_init (&os, ogg_page_serialno (&og));
        if (ogg_stream_pagein (&os, &og) < 0)
          return 1;
        if (ogg_stream_packetout (&os, &op) != 1)
         return 1;

        return 0;
      }
    EOS
    testpath.install resource("oggfile")
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-logg",
                   "-o", "test"
    # Should work on an OGG file
    shell_output("./test < Example.ogg")
    # Expected to fail on a non-OGG file
    shell_output("./test < #{test_fixtures("test.wav")}", 1)
  end
end
