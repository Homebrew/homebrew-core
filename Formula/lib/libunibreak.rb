class Libunibreak < Formula
  desc "Implementation of the Unicode line- and word-breaking algorithms"
  homepage "https://github.com/adah1972/libunibreak"
  url "https://github.com/adah1972/libunibreak/releases/download/libunibreak_7_0/libunibreak-7.0.tar.gz"
  sha256 "8c9a6e121736cd0d5c890ae3ae96f3f4010a19aa040f1dbded833a62a87717d3"
  license "Zlib"
  compatibility_version 2

  livecheck do
    url :stable
    regex(/v?(\d+(?:[_-]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "23a52d6cf9cffb57d86c8a06daf8b47ce0ddcd7688e5a31daf73fbc10d3ca53b"
    sha256 cellar: :any,                 arm64_sequoia: "820ed99a285c5ebc04c5124dc44a2d4ce61fdb27f1ed5e3429b9c29e767238ef"
    sha256 cellar: :any,                 arm64_sonoma:  "447bad02c83e0d39057ba1b350bd0759e0a4f8ba60b5f194f49e80d8cba30ca9"
    sha256 cellar: :any,                 sonoma:        "90367ff83d8a676939c1c37d0ec5f119ef7d79150400f8d69e06dfb3455ffc09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1866075bff3a2f672ed91d549c7fe660de2ae3cf1a2e9a4f367c454705cbcb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fff762dc25ef27872f8d1cd64377a527d12e782248cfa04031e60f2d8aee006"
  end

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
