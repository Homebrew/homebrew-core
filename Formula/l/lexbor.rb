class Lexbor < Formula
  desc "Fast embeddable web browser engine written in C with no dependencies"
  homepage "https://lexbor.com/"
  url "https://github.com/lexbor/lexbor/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "522ad446cd01d89cb870c6561944674e897f8ada523f234d5be1f8d2d7d236b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a0aa4db60e4ea8b69f80c2c6b2a613a20cc303eca5c21b60d105db4fd6a4836d"
    sha256 cellar: :any,                 arm64_sonoma:   "76084d38a071e5e5d39feb88a361e79c7dc06d54ce9e2b3358666c167d8836df"
    sha256 cellar: :any,                 arm64_ventura:  "eccf6f7558e767bee5354ab18cc6d28c673531999900f56f4785c1e736c23ebd"
    sha256 cellar: :any,                 arm64_monterey: "c2cfb1247d22a00a0e7f626496c2a8149db81b8e53ef1761f5de864aa76a2456"
    sha256 cellar: :any,                 arm64_big_sur:  "31d84cbaa368851df3fbd09657e5541bfb1f93b864e197a93779918aa65567e7"
    sha256 cellar: :any,                 sonoma:         "cdde26bb9cd722c2b56c6ff49a35a07328cd28ccc790e005d42163fe1cb1f874"
    sha256 cellar: :any,                 ventura:        "46b1f84d2e8facefef717f69eb8da519e79ff45cd4a2d0993d3cb143f23d3e7e"
    sha256 cellar: :any,                 monterey:       "a7ea7389870f3a69a95b04f58b4fe5ca23ea2c267146ae64ab2ca98411540f1f"
    sha256 cellar: :any,                 big_sur:        "2a09f42f1bcdb49396ad7ad68f2417387614ff3d1a1727cce5a091fc7284dd05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83296bf8b7ae45dcb71f7cb6df21586dd2b026561487e7e65112d7d87a5d2bca"
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
