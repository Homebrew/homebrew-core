class Md4c < Formula
  desc "C Markdown parser. Fast. SAX-like interface"
  homepage "https://github.com/mity/md4c"
  url "https://github.com/mity/md4c/archive/refs/tags/release-0.5.2.tar.gz"
  sha256 "55d0111d48fb11883aaee91465e642b8b640775a4d6993c2d0e7a8092758ef21"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d3c08c51d39761be30ec5c67c297d31af0a1f4d15d02d633a528253dc57c8ef5"
    sha256 cellar: :any,                 arm64_sequoia:  "528d191cb50a6f5901faf2bf989374657792410929d5ac78b1515f412e07ab58"
    sha256 cellar: :any,                 arm64_sonoma:   "5a535b9cec9b6155304abead938f5022fe7522b881dd6e12f6f45c9b4c0f0d3a"
    sha256 cellar: :any,                 arm64_ventura:  "be769f9eb2de4a0c2b3ba400e79b07dc9d6c5f6c0c9e9d032f24bc6c5ef1a916"
    sha256 cellar: :any,                 arm64_monterey: "9fe6e97ee446af5c8999daeabbb4ef4e1e7f3a57d4c5ad60dabe125da501b5e7"
    sha256 cellar: :any,                 sonoma:         "1c0f5cba7d83945b1d458e5dfe5b0fbffd698f7f15a04c63b19f96ed8967a6dc"
    sha256 cellar: :any,                 ventura:        "74a1f6056f0ee6860fa3ea51e0018ccfeabfb6f9db19b3f2ac924c3792c8644a"
    sha256 cellar: :any,                 monterey:       "e1ac92816bcad76852239c7963853b648d99f39d46fee483027ccd3997e104ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bddcdff231d805814edf2992309a92dee28f6db946465d74cae3bb4888509a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70158ffa050cd2f2ca59f5341051208cc96ca416f026e09e8db469683eb93eac"
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
