class Liblc3 < Formula
  desc "Low Complexity Communication Codec library and tools"
  homepage "https://github.com/google/liblc3"
  url "https://github.com/google/liblc3/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "276752ff54ce6a77d54ec133397b9d7e71f90caf3d9afa32d8b0e891b8ecb8af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d948beab725c1b53b092cf3ddbef489e72a04958de5a1dbce4fdce578a703fb7"
    sha256 cellar: :any,                 arm64_sequoia: "997b5d2fdfceb35010b61b89004b9ce8e2a5630aa9c90d1f322e62db53641dae"
    sha256 cellar: :any,                 arm64_sonoma:  "3fc0c2cb6555286a50609efa75f46c88d9addde79781a17165b1bd90e17e14ae"
    sha256 cellar: :any,                 arm64_ventura: "00fa4c793aaa4ccea249c31fab37842e72d5564d581a2b022bde1727ef2c4830"
    sha256 cellar: :any,                 sonoma:        "e0e1764a4d3c5d39c850c2289748cb18789a0f06e4264d88b119f5aebb83bba2"
    sha256 cellar: :any,                 ventura:       "b8c8cb040fcc528c0224dff4e3e8e6a9e016639187ee365d66679afed1dd3458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6377a03378ccbac1bc3dfebd170453ef1e1a1cc6a00d403e226bca898a0d29b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f6f3cff68a823732f72eca5847e4774b34c9d545b1eae5838f4b5cb0b73fc53"
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
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-llc3", "-o", "test"
    system "./test"
  end
end
