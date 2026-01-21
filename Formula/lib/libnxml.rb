class Libnxml < Formula
  desc "C library for parsing, writing, and creating XML files"
  homepage "https://github.com/bakulf/libnxml"
  url "https://github.com/bakulf/libnxml/archive/refs/tags/0.18.5.tar.gz"
  sha256 "263d6424db3cd5f17a9f6300594548e82449ed22af59e9e5534646fa0dabd6a7"
  license "LGPL-2.1-or-later"
  head "https://github.com/bakulf/libnxml.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "4c39575bded5e30f6417654a6d1eabb5a2812401fe97ff351fb3067f76ab7a8a"
    sha256 cellar: :any,                 arm64_sequoia:  "3e49138d11e9bb15e135e9387bb4e1f1d55a7daa354b3caa245e9b25a1b5ace0"
    sha256 cellar: :any,                 arm64_sonoma:   "c7287e418f649ae7a95a152feb06cc43846a286ed8a5b511b490e4a2cac8d341"
    sha256 cellar: :any,                 arm64_ventura:  "6a57d9af9acf0588b0b58903248f8f116639f043bd6b1716d6592c459da3f658"
    sha256 cellar: :any,                 arm64_monterey: "c6887b727e4b7254d5d90c7018cd60c80681624eb0fafe6e8075a8d8313ef6a7"
    sha256 cellar: :any,                 sonoma:         "b33e1d5aef9bbf9f058740832ee647c7c838c23bc2523105b3e1192059f01ddf"
    sha256 cellar: :any,                 ventura:        "5025007cfe5e551c8f0fba852bfadf3bc22f9d631548e6fd15c78fad5b927839"
    sha256 cellar: :any,                 monterey:       "2d3296d3ee6942ded48af843e36539242da4f5fea43cafc406dec3b69f7f5bcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "aeae7a08c735c217cc5cc14eabddbcc883af5933aba7253e3fa020622a6783f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63bb969c6efc96d3bc6c97c4e8faa0dc918ed41bdf9d55e25f372f33b4c4d78e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  uses_from_macos "curl"

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
