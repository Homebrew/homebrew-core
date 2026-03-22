class Lexbor < Formula
  desc "Fast embeddable web browser engine written in C with no dependencies"
  homepage "https://lexbor.com/"
  url "https://github.com/lexbor/lexbor/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "e2473ade7173f69c56731ba71291d2ba705675ede2bb4423dc939ed70bcb55b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e59cc1164c8c337c3e121093013a969d1027b1c31a2874b951a66a864b9e48c"
    sha256 cellar: :any,                 arm64_sequoia: "b851096f26503cf39f5bcdddc02f7896613a08ee2be5b69fef7a6c2c9400259a"
    sha256 cellar: :any,                 arm64_sonoma:  "fb3810bfbcb1fdfadc53d7d9ac79708959f999d0b27dc8e6be0545d2b44a63b4"
    sha256 cellar: :any,                 sonoma:        "2e05d288f16c23d59469d9ce5b7179581db72a6817161f9fa14904fb244836ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72901391b34df2b4ffcd10fa2a4c1707ac85f8bfd6ad9c37a1747b0689c93f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d894a3541135c8f4c4d523e9fe5d3f95b52095056bba92e2a89665ba59d85c5b"
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
