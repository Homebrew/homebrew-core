class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  url "https://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.5.tar.gz"
  sha256 "0eb4b4b9420a0f51db142ba3f9c64b333f826532dc0f48c6410ae51f4799b664"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f18fefb04d186e649753d48a9cffd1ce6a7b7a94fe0470c932eb09ee7b9c4cd5"
    sha256 cellar: :any,                 arm64_monterey: "119687ca3010a96ff903a55160690c62fa3864e8c23b89854b6decf4416f9762"
    sha256 cellar: :any,                 arm64_big_sur:  "86f7182a3e7ad1a6cbc0520424875fcad195c97ee62db95d7b5e863be95eee95"
    sha256 cellar: :any,                 ventura:        "b9d827e7f79a35900950435985b7b88a64e81965237173a02bb1af7a8028b62b"
    sha256 cellar: :any,                 monterey:       "61cbbd4f4b5c7229dce6121d61ca24806c52c435a70b15bf060ca2f2e6412bbc"
    sha256 cellar: :any,                 big_sur:        "b28fe3ad76ad6caafbedb2587deac3b4f03f79cb1466e6f76a06724eaae346ee"
    sha256 cellar: :any,                 catalina:       "e6c116ef9fa7ebac93b5b22fb1208d1d1f4b000fdfdae4b0ae9ec18fe5a5412c"
    sha256 cellar: :any,                 mojave:         "f416f50ef34e470f690e27f3c29f65d6fe5b1aec56f16a2a312ba6011e809720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db517cc6e922b1d3a7c845bad5dd4c78d48b170aa94187d6281f8577f228a180"
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
