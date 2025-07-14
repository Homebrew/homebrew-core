class Lexbor < Formula
  desc "Fast embeddable web browser engine written in C with no dependencies"
  homepage "https://lexbor.com/"
  url "https://github.com/lexbor/lexbor/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "8949744d425743828891de6d80327ccb64b5146f71ff6c992644e6234e63930e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49a5de0e67837102472154ebdb9ce26676d570eadf6a2180ebe9cacc32bb0526"
    sha256 cellar: :any,                 arm64_sonoma:  "b76a6858424ef6ac2dd368d3ef7dcac3203c5767aff21e0a3b12eeb6b10c264a"
    sha256 cellar: :any,                 arm64_ventura: "18858851e6b62f275a59fd82917f88895783e7efc81ab44bd3dc8bf0e99ced57"
    sha256 cellar: :any,                 sonoma:        "5cfa710c1d1eeb449f5572a62145485b4f4f15f2bb13b481d8c8970b8a7b33de"
    sha256 cellar: :any,                 ventura:       "20518f3481290a5b5e6ea9caa2e5e41ba64b2bb3c4d75ee797cd0061c8b1ac6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a061a2d6bf59442960ee085412491903f0090062bc8145b2496537033764ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a6f152a6789ce2fb0139d1c576976c987aee305f5d8e902fc87c939a7fe9b4a"
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
