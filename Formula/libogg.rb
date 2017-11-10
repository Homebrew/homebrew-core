class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  url "https://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.gz"
  sha256 "c2e8a485110b97550f453226ec644ebac6cb29d1caef2902c007edab4308d985"

  bottle do
    cellar :any
    sha256 "cad96a945f371b76925092a518516db8c411c1ada9f402024fde4c2ffd2feaa2" => :high_sierra
    sha256 "652ed73b78106579014bfb727464094004da85ad15aa7655c3076a2d1e587916" => :sierra
    sha256 "dde4684a0247e6b6b27025ff66a35035a9c58492516b6d5c227e8be1eb880685" => :el_capitan
    sha256 "5d203c8e978aee2005f8ae4e85ba1e0451d4a29c8d6f878ada8da5d45f60fe84" => :yosemite
    sha256 "eafa300fd404b5f2a48b9327b8cb320712faf228ff2fbfdac53ad99060f82350" => :mavericks
    sha256 "795ebc059c77ca0087ead3f642a888bfc470953c98104dacee5b6e5d7c5aeaa9" => :mountain_lion
    sha256 "b2b1a8a3bf34fd5f7ea7d60a10fe38e3d699b7344a843599938d1669871c9c8a" => :lion
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
