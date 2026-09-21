class Lexbor < Formula
  desc "Fast embeddable web browser engine written in C with no dependencies"
  homepage "https://lexbor.com/"
  url "https://github.com/lexbor/lexbor/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "08ce3d18efdd09b8b3488779b97509f83cc181e09a5a4cd8162ac08d77266600"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d24c9c977e25a93f2232da550e0e0e8a93e15b69bf35480717fc9b3087929b4b"
    sha256 cellar: :any, arm64_tahoe:       "55e32257e768086f15c2db71ec04445b3aee437f7e7a9ebdfad2ffbe27626a2d"
    sha256 cellar: :any, arm64_sequoia:     "307f9f8603edce1cddf07aa1c7021a1332e5fd3cdf26b8ef4611b49c798088f3"
    sha256 cellar: :any, arm64_sonoma:      "d8a38e8dc86754e0c8f4fa09aa73b6989bed9f008ab1993263888a562bad3ad1"
    sha256 cellar: :any, arm64_linux:       "b58ed24615df1c3330fc86585c41bfb5178a4bfa30916d981b459d2085d5ced3"
    sha256 cellar: :any, x86_64_linux:      "59c8876ba51946f6120fecb8a22d6be1e06bf30f40791b38f62bfe5e476674cb"
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
