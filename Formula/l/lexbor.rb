class Lexbor < Formula
  desc "Fast embeddable web browser engine written in C with no dependencies"
  homepage "https://lexbor.com/"
  url "https://github.com/lexbor/lexbor/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "eafaa79ef9871f0bbb1978eda8677d184f7ecdcaa203d7cd25b3f86e32c014c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "231a737ed10d301c88fcb5c6b372411578faf9cdf22c03f2c0903454e2a0f552"
    sha256 cellar: :any,                 arm64_sequoia: "273ee0120f9722c3158f7e92a272eb1c606b432eac36b3eed213e51548b69bbf"
    sha256 cellar: :any,                 arm64_sonoma:  "c11c11c5e9040f456320e0e7a7ac12d9dfe9b251fd13d8a9f4e327cf1a24a752"
    sha256 cellar: :any,                 sonoma:        "8c7eefc8862cf83d4c79daec3fae265772ce72940cf351cc3ed4c614fe8e4635"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eb786dd2780027958e5879c2d58bea437f491eb5fa2aa1ae94e8c03528cdf4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "071ce43949be15bc761f9546029b129f7510b219103025d08c069b5cc3a5c9b9"
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
