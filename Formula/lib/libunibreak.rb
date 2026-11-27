class Libunibreak < Formula
  desc "Implementation of the Unicode line- and word-breaking algorithms"
  homepage "https://github.com/adah1972/libunibreak"
  url "https://github.com/adah1972/libunibreak/releases/download/libunibreak_8_0_1/libunibreak-8.0.1.tar.gz"
  sha256 "ac0dcc96c395bc86ff7f86f6b91d8b45bc8c39db775f3f1e73f947a11520737b"
  license "Zlib"
  compatibility_version 3

  livecheck do
    url :stable
    regex(/v?(\d+(?:[_-]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    manifest_sha256 "3091b78a4f146803ace395ad601f21b9f3604e81e772e23d7565a75c6bab9455"
    sha256 cellar: :any, arm64_golden_gate: "37e043da80de9d9cc918a656465cccae1fee285d44b493da83f0a98093b7a92a"
    sha256 cellar: :any, arm64_tahoe:       "d3886397eb0c32473b50792a788f54c8243ae68d05a96608875030b870c9b6b9"
    sha256 cellar: :any, arm64_sequoia:     "840390fa9037b1a870aa8c703a8040c137b2699eb80a59f207b1548b4e2d7a04"
    sha256 cellar: :any, arm64_linux:       "c1ac7b388fa8692ff87352efb4add26c49ff9735bce4ac9f1aabfb1d87c8783e"
    sha256 cellar: :any, x86_64_linux:      "4d3efcb62fde85cf06fd5e7b7a0a28fd751f5db0ffdfc8be508871a91c56f0ff"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <unibreakbase.h>
      #include <linebreak.h>
      #include <assert.h>
      #include <stdlib.h>
      #include <string.h>
      int main() {
        static const utf8_t input[] = "test\\nstring \xF0\x9F\x98\x8A test";
        char output[sizeof(input) - 1];
        static const char expected[] = {
          2, 2, 2, 2, 0,
          2, 2, 2, 2, 2, 2, 1,
          3, 3, 3, 2, 1,
          2, 2, 2, 4
        };

        assert(sizeof(output) == sizeof(expected));

        init_linebreak();
        set_linebreaks_utf8(input, sizeof(output), NULL, output);

        return memcmp(output, expected, sizeof(output)) != 0;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lunibreak"
    system "./test"
  end
end
