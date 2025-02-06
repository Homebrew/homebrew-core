class Liblc3 < Formula
  desc "Low Complexity Communication Codec library and tools"
  homepage "https://github.com/google/liblc3"
  url "https://github.com/google/liblc3/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "6903e2ea3221fcd55d03b9ab390a7921f7ef2147a3934155690664b30d6ff9ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "36b49aa6444c3a17440f2590aa83e3ffabc06b5230ebb607fc96975ee019e3a3"
    sha256 cellar: :any,                 arm64_sonoma:  "478bbd8548ab3034dc0731593b0ada9d999f63a004b99634b297925a974b89f1"
    sha256 cellar: :any,                 arm64_ventura: "316420a59e0580f02eb43a75035b82a51ed3a881b7bbedae7e45ed1aaf4aeb1c"
    sha256 cellar: :any,                 sonoma:        "490f992c96cfb8b4c71f94a10a57cbdc2f4191bb31ba73e8e25067689717a86e"
    sha256 cellar: :any,                 ventura:       "ecb61d892d0a6b2f7df4d7b1ea0991c1c69551c33c7e6e07b8f9733ba023587c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca49f4e46a38cb4933d8289af6cd676343f164713b23c0cc23b23f2557699b50"
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
