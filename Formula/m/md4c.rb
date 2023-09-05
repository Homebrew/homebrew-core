class Md4c < Formula
  desc "C Markdown parser. Fast. SAX-like interface"
  homepage "https://github.com/mity/md4c"
  url "https://github.com/mity/md4c/archive/release-0.4.8.tar.gz"
  sha256 "4a457df853425b6bb6e3457aa1d1a13bccec587a04c38c622b1013a0da41439f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8057cee0cc192a2db1c29a4a49a3c9b175891b9c2aff8b0481a64c8da807d4b3"
    sha256 cellar: :any,                 arm64_monterey: "154f5f1eb77492727a5475922c642db680724a1b5abbd221b6ac65cb0d4c7c52"
    sha256 cellar: :any,                 arm64_big_sur:  "1873e516760235dba2670bb63a612b99b51714baf657b99c2c411da40c3162ec"
    sha256 cellar: :any,                 ventura:        "4ab00b6654d56bdf2805cfcec8b4bec4ff1704a0cf499fafc5fd451b86c9fe78"
    sha256 cellar: :any,                 monterey:       "29d7e311c2821193496c531b4f8bec1d3857d5bd949da3578ee1abc6e9d2d20c"
    sha256 cellar: :any,                 big_sur:        "8b4ae9a5232e84db3d0ab6793a8dd5bd56071fb32832fd94d16fa8162ec08a16"
    sha256 cellar: :any,                 catalina:       "8368b905e33301b5019e8520f7d010e3a57f74855ebd5cbbbf87aa1d8ded50a7"
    sha256 cellar: :any,                 mojave:         "ad888318dd048fc87594ff6a67321b9f9711bafb835f121f46f8f3e31de1931a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53d6b4590104e353ecbc591400815db823603d960894dc5a5fb1a84306290580"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # test md2html
    (testpath/"test_md.md").write <<~EOS
      # Title
      some text
    EOS
    system bin/"md2html", "./test_md.md"

    # test libmd4c
    (testpath/"test_program.c").write <<~EOS
      #include <stddef.h>
      #include <md4c.h>

      MD_CHAR* text = "# Title\\nsome text";

      int test_block(MD_BLOCKTYPE type, void* detail, void* data) { return 0; }
      int test_span(MD_SPANTYPE type, void* detail, void* data) { return 0; }
      int test_text(MD_TEXTTYPE type, const MD_CHAR* text, MD_SIZE size, void* userdata) { return 0; }
      int main() {
        MD_PARSER parser = {
          .enter_block = test_block,
          .leave_block = test_block,
          .enter_span = test_span,
          .leave_span = test_span,
          .text = test_text
        };
        int result = md_parse(text, sizeof(text), &parser, NULL);
        return result;
      }
    EOS
    system ENV.cc, "test_program.c", "-L#{lib}", "-lmd4c", "-o", "test_program"
    system "./test_program"
  end
end
