class Lexbor < Formula
  desc "Fast embeddable web browser engine written in C with no dependencies"
  homepage "https://lexbor.com/"
  url "https://github.com/lexbor/lexbor/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "d89060bb2fb6f7d0e0f399495155dd15e06697aa2c6568eab70ecd4a43084ba9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa07a7e0a41b67d359381439e20d2d60fd9487aa7dbba4c921b510c1f913c3b9"
    sha256 cellar: :any,                 arm64_sequoia: "7ed40db97faebbb07600bc257d2c6ea325c5f5b8c15e5bd77f5e5c05dff26208"
    sha256 cellar: :any,                 arm64_sonoma:  "f9e37f56f77cd01db352e708eb01e4489883c2112badc4dd473cf8ad24c3af5c"
    sha256 cellar: :any,                 arm64_ventura: "e4c182da09668cd4e83b229013fbb0502fabbc9334f493dd2a92675049b0b918"
    sha256 cellar: :any,                 sonoma:        "32672d3e3b6beceab8508bd2284304e27042abf56c56f5b5e3dfef58f2b881f0"
    sha256 cellar: :any,                 ventura:       "549fdf335440f54625f93ebfcd53fc64b94b1ad9ee3b00cf36ee31f80bce12d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db10aba8612b5f33e8aa0a627de2a5ef9411e79d0e951c2db09aa0b6471ac3e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9103ecec5668ac0e512d3f6edfc55690ffcd562a2cd552432162469108bcad67"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <lexbor/html/parser.h>
      int main() {
        static const lxb_char_t html[] = "<div>Hello, World!</div>";
        lxb_html_document_t *document = lxb_html_document_create();
        if (document == NULL) { exit(EXIT_FAILURE); }
        lxb_status_t status = lxb_html_document_parse(document, html, sizeof(html) - 1);
        if (status != LXB_STATUS_OK) { exit(EXIT_FAILURE); }
        lxb_html_document_destroy(document);
        return EXIT_SUCCESS;
      }
    CPP

    system ENV.cc, "test.cpp", "-L#{lib}", "-llexbor", "-o", "test"
    system "./test"
  end
end
