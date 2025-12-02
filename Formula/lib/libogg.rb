class Libogg < Formula
  desc "Ogg Bitstream Library"
  homepage "https://www.xiph.org/ogg/"
  url "https://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.6.tar.gz"
  mirror "https://github.com/xiph/ogg/releases/download/v1.3.6/libogg-1.3.6.tar.gz"
  sha256 "83e6704730683d004d20e21b8f7f55dcb3383cdf84c0daedf30bde175f774638"
  license "BSD-3-Clause"
  head "https://gitlab.xiph.org/xiph/ogg.git", branch: "main"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/ogg/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)libogg[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d9d14f8e36ed913c02201bfc01682ba3f550de412e9a24e3ef9aed4f1b8a23d"
    sha256 cellar: :any,                 arm64_sequoia: "2423ff6b931f0393cd314052a7328a61fdd6f1d8519b65c4dff5ab560f82c52d"
    sha256 cellar: :any,                 arm64_sonoma:  "b6ec0e6b292eab3768d90933a2e663aa8a43951f601dab9bd418b1a6564f4925"
    sha256 cellar: :any,                 arm64_ventura: "82439bd6c8699a8d97e99ba675199a4f7f85473a2a5e7242dfa471329eeb85e9"
    sha256 cellar: :any,                 sonoma:        "7a0ea60e18a7c1da00972c28055638f1ddd1335f3be74821cb9df40dab680f7b"
    sha256 cellar: :any,                 ventura:       "bff42905e8a218e8d1699740568c7bc42bf4316f21c6fce7e6a3c90ab0e816ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7262ddbb97a7421a59bc2cc3bc1574bbb6a440ec6d825a0b5794c79eb89adc8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4fb064699caad0097ce135c7212022d1dc230424fb3b63c379731ab44ea8e42"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libogg.a"
  end

  test do
    resource "oggfile" do
      url "https://upload.wikimedia.org/wikipedia/commons/c/c8/Example.ogg"
      sha256 "f57b56d8aae4c847cf01224fb45293610d801cfdac43d932b5eeab1cd318182a"
    end

    (testpath/"test.c").write <<~C
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

        // Read all available input to avoid broken pipe
        do {
          buffer = ogg_sync_buffer (&oy, 4096);
          bytes = fread(buffer, 1, 4096, stdin);
          ogg_sync_wrote (&oy, bytes);
        } while (bytes == 4096);

        if (ogg_sync_pageout (&oy, &og) != 1)
          return 1;
        ogg_stream_init (&os, ogg_page_serialno (&og));
        if (ogg_stream_pagein (&os, &og) < 0)
          return 1;
        if (ogg_stream_packetout (&os, &op) != 1)
         return 1;

        return 0;
      }
    C
    testpath.install resource("oggfile")
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-logg",
                   "-o", "test"

    # Should work on an OGG file
    pipe_output("./test", (testpath/"Example.ogg").read, 0)

    # Expected to fail on a non-OGG file
    pipe_output("./test", test_fixtures("test.wav").read, 1)
  end
end
