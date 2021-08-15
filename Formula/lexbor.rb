class Lexbor < Formula
  desc "Fast embeddable web browser engine written in C with no dependencies"
  homepage "https://lexbor.com/"
  url "https://github.com/lexbor/lexbor/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "f3aeeb0c47d9d34b7b32411ce6a8fe833b825fa21730a593c32f53c9834a3f0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "101be3010f94da5bd1d1a73570ef113b4c8cbb00811c6e85e5e3651362c0617a"
    sha256 cellar: :any, big_sur:       "1531d24359e5ab1a8f02c54b779a987b84ca75e2389076d701f641471c549b19"
    sha256 cellar: :any, catalina:      "53fe30aaa102edf50663e465c0bb4c5107113c2d304934d457b084bfc11a6c06"
    sha256 cellar: :any, mojave:        "d8975317af905c54d37cf93d82428627202dcfaaec81472022dc8f566cf2e738"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-llexbor", "-o", "test"
    system "./test"
  end
end
