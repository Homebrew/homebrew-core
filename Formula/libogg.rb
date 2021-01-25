class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  license "BSD-3-Clause"

  stable do
    url "https://downloads.xiph.org/releases/ogg/libogg-1.3.4.tar.gz"
    sha256 "fe5670640bd49e828d64d2879c31cb4dde9758681bb664f9bdbf159a01b0c76e"

    # os_types: fix unsigned typedefs for MacOS. This is already merged upstream; remove on next version
    patch do
      url "https://github.com/xiph/ogg/commit/c8fca6b4a02d695b1ceea39b330d4406001c03ed.patch?full_index=1"
      sha256 "0f4d289aecb3d5f7329d51f1a72ab10c04c336b25481a40d6d841120721be485"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "47c3224ac25b17a201e234f8fabcb9249b7d1587e69c63e025578c5a6d448ab3" => :big_sur
    sha256 "9c217f3aa8ea00c0536a8b90df566aeb32fb4ffee56f85b94d9eb6f6ae68f21b" => :arm64_big_sur
    sha256 "b95bbf935f48878bd96d1c0e6557a017aa18cb17a080bc3ef9308b6415c278ef" => :catalina
    sha256 "3cc7656859154f6eb98d3ddbe4b74c810b505e2162af1357b3ed6b70cad35125" => :mojave
    sha256 "95f271ec181f6b999674636272a3414db4242eabd0a0b0572cfa0f1f324f5ef8" => :high_sierra
  end

  head do
    url "https://gitlab.xiph.org/xiph/ogg.git"

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
