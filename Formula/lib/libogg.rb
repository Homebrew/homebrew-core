class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  url "https://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.5.tar.gz"
  sha256 "0eb4b4b9420a0f51db142ba3f9c64b333f826532dc0f48c6410ae51f4799b664"
  license "BSD-3-Clause"
  head "https://gitlab.xiph.org/xiph/ogg.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "13592df33977148bd6ca571b333892b42b1d988289a47f4efd3979fd48964b3e"
    sha256 cellar: :any,                 arm64_sonoma:   "f5da0b4874b723ca02947cd2312df9cdd37bc7b6e000e9e6cdd9bbbb290dc0e9"
    sha256 cellar: :any,                 arm64_ventura:  "d241e81018d3b64ec0d491d5d43f5409496747d57fb8d0eff75c534bd84dd19a"
    sha256 cellar: :any,                 arm64_monterey: "aa2b793e007a3eb86a8b225b91561ecf1dc941071596d23f810ca41e83904d5d"
    sha256 cellar: :any,                 arm64_big_sur:  "e528165137cd229e4ac1147bd9c5f6de5aafb815c25d00682a923baaa621bc1d"
    sha256 cellar: :any,                 sonoma:         "d8591422a6ab90f2d890e14cde9c608baac46166abcce2a27978a63573b0d243"
    sha256 cellar: :any,                 ventura:        "517e16f78d047709c010bd3f31e6497c93c562db71f9b2022395f0a2fcb4c62d"
    sha256 cellar: :any,                 monterey:       "6e8d8540b1cd602e3ed6f6713fcb82c423a69ca1620f447f4c67b03fe04589c2"
    sha256 cellar: :any,                 big_sur:        "7871f4d805f54347ab3ac20a7dbd31d78a122bf0cd2da441a45a2b1cf732551c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be528587bb8d4c822dfbee4bb30705c9511908d86ae5f5859eb9c59eb7459ef3"
  end

  depends_on "cmake" => :build

  resource("oggfile") do
    url "https://upload.wikimedia.org/wikipedia/commons/c/c8/Example.ogg"
    sha256 "f57b56d8aae4c847cf01224fb45293610d801cfdac43d932b5eeab1cd318182a"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libogg.a"
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
