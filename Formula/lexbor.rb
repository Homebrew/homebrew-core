class Lexbor < Formula
  desc "Fast embeddable web browser engine written in C with no dependencies"
  homepage "https://lexbor.com/"
  url "https://github.com/lexbor/lexbor/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "f3aeeb0c47d9d34b7b32411ce6a8fe833b825fa21730a593c32f53c9834a3f0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "049e9dcce3ab4f13d659346cd8e437df6fa1436835148cd77b9a692c892247a5"
    sha256 cellar: :any, arm64_big_sur:  "7ff7b35d9f6c4eb4ed63a7dde659430d17ca5c48564d6702dc9b4e1ea955592c"
    sha256 cellar: :any, monterey:       "f6d5df6a5a8b4a0c68276927883bcf9950d79e0c8534671345be60abb8cf5eda"
    sha256 cellar: :any, big_sur:        "e553e88f89c5fb07eb2e5da0950888f1f8e60a6c23c05999119f5fdc50acc9a2"
    sha256 cellar: :any, catalina:       "717a39abae12061410e36356219b4f44a31d4ca6c050966d48a5cf941ac13421"
    sha256 cellar: :any, mojave:         "d6ad60202c6e4b55b3a88fedd550a87c644592ff42d391f322d177ca7bbbf829"
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
