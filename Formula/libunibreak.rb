class Libunibreak < Formula
  desc "Implementation of the Unicode line- and word-breaking algorithms"
  homepage "https://github.com/adah1972/libunibreak"
  url "https://github.com/adah1972/libunibreak/releases/download/libunibreak_5_0/libunibreak-5.0.tar.gz"
  sha256 "58f2fe4f9d9fc8277eb324075ba603479fa847a99a4b134ccb305ca42adf7158"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "775a04ffdd0c01bac19771fe2c5303754f6115cab75ac1250f9a102b857fe2ff"
    sha256 cellar: :any,                 arm64_monterey: "b91e754103c6bb5aa904600a71a1ee42253ca926735774ffb064e79ba1d9991f"
    sha256 cellar: :any,                 arm64_big_sur:  "0ae94966529158d232ab948c46bc30beea344c9da931f7e9ff2cac1d0b6880c2"
    sha256 cellar: :any,                 monterey:       "ad57180899438208c7c3b6ad6220e307679d96f1bf754bce5f0f0f1e88f53906"
    sha256 cellar: :any,                 big_sur:        "724143d46ab6847b398095d469f94235ec56093770c27fa051ad69cb5c495098"
    sha256 cellar: :any,                 catalina:       "422f9835c3b516405b171b77d4ed95939977300ed5c816d11c9fc0a88c28eeb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cda3ecadbd187045895d6133c2e6828e8717e0956dbb074efe93fa31afc12d0d"
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
