class Libnxml < Formula
  desc "C library for parsing, writing, and creating XML files"
  homepage "https://github.com/bakulf/libnxml"
  # Update to use an archive from GitHub once there's a release after 0.18.3
  url "https://www.autistici.org/bakunin/libnxml/libnxml-0.18.3.tar.gz"
  sha256 "0f9460e3ba16b347001caf6843f0050f5482e36ebcb307f709259fd6575aa547"
  license "LGPL-2.1-or-later"
  head "https://github.com/bakulf/libnxml.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "4eacea651f361f6159331989db43fcb5b88df845d5e3873c583a049826fcdc5f"
    sha256 cellar: :any,                 arm64_monterey: "7b9f770e09e58cede9baff8e2cb8b588529368a451ea876edc7d72edb00e324b"
    sha256 cellar: :any,                 arm64_big_sur:  "c9fb3bcc767561392f500093ca5549248153ba874b7d3df6ae17a9a94c9135b7"
    sha256 cellar: :any,                 ventura:        "0630539c78edcfe2b7af9362a3928c41cbc578e64df98e22e10d5f83bc05e94c"
    sha256 cellar: :any,                 monterey:       "db15774e70f1d15202c5c3a0412c87bf2a40625064976ee71b004c9f2a9f439a"
    sha256 cellar: :any,                 big_sur:        "646e960c9d78476dd4102b5ede1aac8bf0ea3dd06f51de6cec429f0851b4f1ec"
    sha256 cellar: :any,                 catalina:       "af92d830dbb7a103cd5a512c03c1cf2777742ea72c998ecbf1fc80912679cb47"
    sha256 cellar: :any,                 mojave:         "61e076a06cab737a7410a8a2adf9c29c3d32e44467caaef25d54c7be63093bd6"
    sha256 cellar: :any,                 high_sierra:    "a6b51b3ed4d09a603b7d232040b7e53fb26013a16ea9b4b86f415c45200faf43"
    sha256 cellar: :any,                 sierra:         "ddeb6f19f803f29eb44f498ed687dd76a5bdeb0b6416c67759e1690ab9fa4f14"
    sha256 cellar: :any,                 el_capitan:     "de106efa2da60ccb8567403547f904485c1c6431dd492ce4e1bbd66599c7f961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea65c2b532c9c55ac17f22075d0d4efbf83fbf36c522c57d797e9faa037588e1"
  end

  # Regenerate `configure` to avoid `-flat_namespace` bug.
  # None of our usual patches apply.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "curl"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <root>Hello world!<child>This is a child element.</child></root>
    EOS

    (testpath/"test.c").write <<~EOS
      #include <nxml.h>

      int main(int argc, char **argv) {
        nxml_t *data;
        nxml_error_t err;
        nxml_data_t *element;
        char *buffer;

        data = nxmle_new_data_from_file("test.xml", &err);
        if (err != NXML_OK) {
          printf("Unable to read test.xml file");
          exit(1);
        }

        element = nxmle_root_element(data, &err);
        if (err != NXML_OK) {
          printf("Unable to get root element");
          exit(1);
        }

        buffer = nxmle_get_string(element, &err);
        if (err != NXML_OK) {
          printf("Unable to get string from root element");
          exit(1);
        }

        printf("%s: %s\\n", element->value, buffer);

        free(buffer);
        nxmle_free(data);
        exit(0);
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnxml", "-o", "test"
    assert_equal("root: Hello world!\n", shell_output("./test"))
  end
end
