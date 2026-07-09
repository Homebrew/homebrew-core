class Md4c < Formula
  desc "C Markdown parser. Fast. SAX-like interface"
  homepage "https://github.com/mity/md4c"
  url "https://github.com/mity/md4c/archive/refs/tags/release-0.5.3.tar.gz"
  sha256 "353c346f376b87c954a13f3415ede2d51264cc61dc5abcd38ff1d2aa0d059b9e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32f2359b9c497452dfc897a44bdd10031aa1a2f1d85639844942bd844bf2a42c"
    sha256 cellar: :any,                 arm64_sequoia: "2d0ec98420dcb79e21758f1cc32043bfbebfbf0e5195f44968507092f30b29a7"
    sha256 cellar: :any,                 arm64_sonoma:  "d3e2962165abbffe5cf6f50e0c220b4baa9ee453bf64ec92043abfe249f881ba"
    sha256 cellar: :any,                 sonoma:        "1989ec20fcab62d4fb41a900ad7ab3fe3e35aadc92200c4df8832f4028881708"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "222c0c3879934ca82c72c87568a501bdfe4e68c27d6ed9c0ec9918567e768e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43976f4c7033d21274f1891ee268a129d8680cc3514bd14016b4bf5d7de45bdd"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # test md2html
    (testpath/"test_md.md").write <<~MARKDOWN
      # Title
      some text
    MARKDOWN
    system bin/"md2html", "./test_md.md"

    # test libmd4c
    (testpath/"test_program.c").write <<~C
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
    C
    system ENV.cc, "test_program.c", "-L#{lib}", "-lmd4c", "-o", "test_program"
    system "./test_program"
  end
end
