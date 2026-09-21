class Libunibreak < Formula
  desc "Implementation of the Unicode line- and word-breaking algorithms"
  homepage "https://github.com/adah1972/libunibreak"
  url "https://github.com/adah1972/libunibreak/releases/download/libunibreak_8_0/libunibreak-8.0.tar.gz"
  sha256 "9c4fad6e517338a098373acc9f35579ae2c325e6446666fb9ac2666ba15ceba4"
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
    sha256 cellar: :any, arm64_golden_gate: "aacd69ecf3c43aca5ffd2b37d41cb7de99fd5a1d2e48ffc9cdf2c0a66c717408"
    sha256 cellar: :any, arm64_tahoe:       "b5ea43d5ae7e12db466b52c75ae517be48aa31c270e9dbb2cb8a9412d94f1aff"
    sha256 cellar: :any, arm64_sequoia:     "fdd04ab1291384622b07b5409786fd297ddb2ceec4715074f9f35c807649ff50"
    sha256 cellar: :any, arm64_linux:       "216db2d318c3de5b050e09fc11eda2e201f2e6fdab7a1efc32614a77831fe7c5"
    sha256 cellar: :any, x86_64_linux:      "b26dbb5d7886f37e4300d510a1d0947b5044ed4871039a4064cb258bf21e1083"
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
