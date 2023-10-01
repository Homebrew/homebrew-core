class Libunibreak < Formula
  desc "Implementation of the Unicode line- and word-breaking algorithms"
  homepage "https://github.com/adah1972/libunibreak"
  url "https://github.com/adah1972/libunibreak/releases/download/libunibreak_5_1/libunibreak-5.1.tar.gz"
  sha256 "dd1a92d4c5646aa0e457ff41d89812ec5243863be6c20bbcb5ee380f3dd78377"
  license "Zlib"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[_-]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3e2150380d94e0adf1aba9eaa99db4684a02894f285b639b1480803f494d9277"
    sha256 cellar: :any,                 arm64_ventura:  "7dfc308bb0fdaf546e5d27a9c0c871778231e8f8624e5cf375da8e634b9e21f4"
    sha256 cellar: :any,                 arm64_monterey: "83a5da767d81cc13dbd79a926769487ad9e27b312a064d6d103116045ca00e69"
    sha256 cellar: :any,                 arm64_big_sur:  "8d491d6d388f52ec3eb2f8966e5cb996ccf1453d11da714d6eff56c66af0af78"
    sha256 cellar: :any,                 sonoma:         "e785da6b43150cf0459775758b3a0ad841fce35184dc23ca99e7a25f12f9bde9"
    sha256 cellar: :any,                 ventura:        "5dd562fc1618a99274e48e1d1401134bf64af893b2659bbb61167885e340b55f"
    sha256 cellar: :any,                 monterey:       "6a12dc2fefb6fa8d558194d964410f0f4858415749898a9107902a2762a9a177"
    sha256 cellar: :any,                 big_sur:        "b030a2efa4e9ef197a28a6db5b174a0682a757920ddb93d569aea159d88545d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2603a6cda73dad46b8929b3a155aa5326fa74c1ed927b812b4fc404e547dbba"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lunibreak"
    system "./test"
  end
end
