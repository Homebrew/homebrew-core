class Liblc3 < Formula
  desc "Low Complexity Communication Codec library and tools"
  homepage "https://github.com/google/liblc3"
  url "https://github.com/google/liblc3/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "958725e277685f9506d30ea341c38a03b245c3b33852cd074da6c8857525e808"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6d45a4d76d487a56ba784b7ff8f0180cb001186bee0c404bb2fb7b46f120275c"
    sha256 cellar: :any,                 arm64_ventura:  "a2198a75a7568fee969e52f53a166a874cde30d15f556e5d1fcd1a2a7b6e7827"
    sha256 cellar: :any,                 arm64_monterey: "6d74073bb134615ed49e44c1652ca64af21260ff13dd34c5cf6c688e502eeb35"
    sha256 cellar: :any,                 sonoma:         "ed537cda08e81cb4d852e04f3793d32d240e66b1b9439ed4f2a0a7535bdf6343"
    sha256 cellar: :any,                 ventura:        "49f51813477d4ee1bac7b04b3139279cc666baef5f053e143e7c6245d57ae324"
    sha256 cellar: :any,                 monterey:       "07c8767c1298cf3827fa2fe9757a1d77fd06fc21dd587801afb8b2200ab85657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a0a63d27a506e4fbae64b4d52f232a8fc2646634a0f79c3dc0ae2f0f683e650"
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
