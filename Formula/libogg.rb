class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  url "https://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.5.tar.gz"
  sha256 "0eb4b4b9420a0f51db142ba3f9c64b333f826532dc0f48c6410ae51f4799b664"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "273ec2cb3abd99d4aee0c8ac2523f5f3140457e6fc658b02168678a557299a43"
    sha256 cellar: :any,                 arm64_monterey: "ce419864291a500b33b1e0cc7afa0c8a060cecf4adf2ef50d2d213f35f021822"
    sha256 cellar: :any,                 arm64_big_sur:  "0f44d59f86d7cd828aa3fd70ba363455fdbfa01bcec6364a286c1db1f7168c29"
    sha256 cellar: :any,                 ventura:        "52e5a973dfdfcb61357e7c80c4e3250742a56dec94650c9546a4a640b749192e"
    sha256 cellar: :any,                 monterey:       "d4d289f5ab37ed438ceecb653ef3cbe23bbac53dbeb550a54c3ebef39f109681"
    sha256 cellar: :any,                 big_sur:        "39a4c4d11e1a495a1cd167183c935634c10e9a75c222185d1e99df1710ffd353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f32a15a651d53059f085695d189c2cfdbd7ee281ee3056b1b107eb07cead6965"
  end

  head do
    url "https://gitlab.xiph.org/xiph/ogg.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  resource("oggfile") do
    url "https://upload.wikimedia.org/wikipedia/commons/c/c8/Example.ogg"
    sha256 "f57b56d8aae4c847cf01224fb45293610d801cfdac43d932b5eeab1cd318182a"
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
