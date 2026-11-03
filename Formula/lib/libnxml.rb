class Libnxml < Formula
  desc "C library for parsing, writing, and creating XML files"
  homepage "https://github.com/bakulf/libnxml"
  url "https://github.com/bakulf/libnxml/archive/refs/tags/0.18.6.tar.gz"
  sha256 "c6de3c486f37c064eeae7d94e74f8dd25328e23effd8409a26a1170c19203ab4"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/bakulf/libnxml.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d63a311d1bf0bf235b8daa053c37e01a85bb3470e74529cf1d82255b64fde8f2"
    sha256 cellar: :any, arm64_tahoe:       "73226db738bdc3ed56aa6881d2d26d7abff7f6149b14412cb02da556af835d56"
    sha256 cellar: :any, arm64_sequoia:     "2e09599d025ca50a967eeb385e630589c6755633e49a1456a6c2e73360bf4e67"
    sha256 cellar: :any, arm64_linux:       "ac69cdb84e9c1476ea4d457b790d43fc62f38cf1dc1ad09e7f6dcbb0be7d3f38"
    sha256 cellar: :any, x86_64_linux:      "51aab30b0421595917785b80d4efec5e769f859280daf6cd8649ad1737caab95"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  uses_from_macos "curl"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <root>Hello world!<child>This is a child element.</child></root>
    XML

    (testpath/"test.c").write <<~C
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
    C

    flags = shell_output("pkgconf --cflags --libs nxml").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_equal "root: Hello world!\n", shell_output("./test")
  end
end
