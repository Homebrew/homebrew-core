class Md4c < Formula
  desc "C Markdown parser. Fast. SAX-like interface"
  homepage "https://github.com/mity/md4c"
  url "https://github.com/mity/md4c/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "4d151298125a81da3b2efa2e0eed8bdb7a9318569804e4fa4d7a2375ab83ef70"
  license "MIT"
  head "https://github.com/mity/md4c.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "39d01500e866f6e934898a804827632f1ad6ed19a3cb077ce1ebfbbd3c277779"
    sha256 cellar: :any, arm64_tahoe:       "e332bdecfcbea2fdf20eb00fd1fcc973970aad2765c2a239b4e1a85617df9291"
    sha256 cellar: :any, arm64_sequoia:     "480a50456cf91e1ed3d04f1ef33e617f0febbc472f26880ae1bc6c903c3f535d"
    sha256 cellar: :any, arm64_linux:       "033936261176a8211d449226d12ad01ba7f911492e6446062da1f0b9b6ac6761"
    sha256 cellar: :any, x86_64_linux:      "53c8c2e65e2867b21cb7b65165f5386b8b4015b3529a0f6b19bce2717029478c"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
