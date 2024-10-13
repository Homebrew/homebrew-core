class Liblc3 < Formula
  desc "Low Complexity Communication Codec library and tools"
  homepage "https://github.com/google/liblc3"
  url "https://github.com/google/liblc3/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "b65e38943708529efd04a87dd1a9f16a9856ed6199d082b18e7d42fb5c59486e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e9a021e1b2ff09d3d5d0c9e654d16a5e49ba9fa88a19d294782942b291be54bb"
    sha256 cellar: :any,                 arm64_sonoma:   "31cc6967823fa5b4165ce896967f32ac5bbc02472d3ed7e72ee86abe33753aea"
    sha256 cellar: :any,                 arm64_ventura:  "5b63ef2dd2e95e3427998c35795e0ca23b017642f7e8a3d62959e385fff7bcfe"
    sha256 cellar: :any,                 arm64_monterey: "01744ca56d9e0598e2d9a63dbfb5f962d74160e33cd801c8fde4d2ade0d9262d"
    sha256 cellar: :any,                 sonoma:         "ddf86429985f1d4c8babba0e04842feb024c8685e7fa310efc29f3d145ddbc75"
    sha256 cellar: :any,                 ventura:        "f8c16dc68ccc1bdbd34ca7d7102c4e8b16c87c94561b3bb976bd3cc8c49d8078"
    sha256 cellar: :any,                 monterey:       "2867ca66ecc693c85fd192db53e4954fd4251a93acb844f8d4dbe5784ac4273d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7fb12461311309877014ab7c777c513917051b340c57accce47f4ef830aeedb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  uses_from_macos "python"

  def install
    # disable tools build due to rpath issue, see https://github.com/google/liblc3/pull/53
    args = %w[
      -Dtools=false
      -Dpython=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "lc3.h"
      #include <stdio.h>
      #include <stdlib.h>

      int main() {
          int frame_duration_us = 10000; // 10 ms frame duration
          int sample_rate_hz = 48000;    // 48 kHz sample rate

          // Memory allocation for encoder and decoder
          size_t encoder_mem_size = lc3_encoder_size(frame_duration_us, sample_rate_hz);
          void* encoder_mem = malloc(encoder_mem_size);
          if (!encoder_mem) {
              printf("Failed to allocate memory for the encoder.\\n");
              return 1;
          }

          size_t decoder_mem_size = lc3_decoder_size(frame_duration_us, sample_rate_hz);
          void* decoder_mem = malloc(decoder_mem_size);
          if (!decoder_mem) {
              printf("Failed to allocate memory for the decoder.\\n");
              free(encoder_mem);
              return 1;
          }

          // Setup encoder and decoder
          lc3_encoder_t encoder = lc3_setup_encoder(frame_duration_us, sample_rate_hz, 0, encoder_mem);
          if (!encoder) {
              printf("Failed to setup the encoder.\\n");
              free(encoder_mem);
              free(decoder_mem);
              return 1;
          }

          lc3_decoder_t decoder = lc3_setup_decoder(frame_duration_us, sample_rate_hz, 0, decoder_mem);
          if (!decoder) {
              printf("Failed to setup the decoder.\\n");
              free(encoder_mem);
              free(decoder_mem);
              return 1;
          }

          printf("LC3 encoder and decoder setup was successful.\\n");

          free(encoder_mem);
          free(decoder_mem);
          printf("Cleanup completed.\\n");

          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-llc3", "-o", "test"
    system "./test"
  end
end
