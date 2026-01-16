class Lexbor < Formula
  desc "Fast embeddable web browser engine written in C with no dependencies"
  homepage "https://lexbor.com/"
  url "https://github.com/lexbor/lexbor/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "e9bb1aa8027ab92f11d5e8e6e7dc9b7bd632248c11a288eec95ade97bb7951a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ee57c229e8b66be3cac8720e2a29b48faa079b6d6361fc9b8fe8010f81f76c9"
    sha256 cellar: :any,                 arm64_sequoia: "67d84841e20b9ef5d849efe266199243fc0b3cb30c3df3fd7fb02d2e64da1b74"
    sha256 cellar: :any,                 arm64_sonoma:  "2ee12217b12ecc341a022deaacc5051d89bb645dc21792b71a1a88415cee1ad5"
    sha256 cellar: :any,                 sonoma:        "1038e977c87d3f6de9bb00c2690eb394ddf19c1038d4f482d6dd9284b4be8f1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81a7542be3ca8d0bdef3bdfc2e7807a2f73c4beee682fb37c1631c125edfa613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa076c7d9dfeb465173bb66340b467e46524e95d607bbc645d8e5919449fc283"
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
