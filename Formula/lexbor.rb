class Lexbor < Formula
  desc "Fast embeddable web browser engine written in C with no dependencies"
  homepage "https://lexbor.com/"
  url "https://github.com/lexbor/lexbor/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "0583bad09620adea71980cff7c44b61a90019aa151d66d2fe298c679b554c57d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ceb8da66d0a103914aaaad881d59463c08cabc2ad4f203cf4be2d471f3abeb07"
    sha256 cellar: :any,                 arm64_monterey: "fd3d8997a6c9ff59c8a0b43a394a96e6b7abf28ac4e2620e04207d6d6cb86fd8"
    sha256 cellar: :any,                 arm64_big_sur:  "a07d0bbee8d40b4fd3c6786ae121f8ba4ef2952b0f63efbe4542869965e8eab1"
    sha256 cellar: :any,                 ventura:        "0058757c572e04dc5ed0d4306de5d9ff07eb10a4f1e623fba23fd25960bde1f0"
    sha256 cellar: :any,                 monterey:       "6f7654be0b373cbe6302adec80bb2b27507d6bb5cc14c8085768213f396a2a96"
    sha256 cellar: :any,                 big_sur:        "49f8426e919a81a80e3a57f5eb7560552dd3d1c74b334e0ce1b36f43cc9fa2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "169819d83011bfbe7e967db30cab777fe073dfd7bba09bcff0ca9d81887ffb85"
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
