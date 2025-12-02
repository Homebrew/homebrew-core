class Canfigger < Formula
  desc "Simple configuration file parser library"
  homepage "https://github.com/andy5995/canfigger/"
  url "https://github.com/andy5995/canfigger/releases/download/v0.3.0/canfigger-0.3.0.tar.xz"
  sha256 "3d813e69e0cc3a43c09cf565138ac1278f7bcea74053204f54e3872c094cb534"
  license "GPL-3.0-or-later"
  head "https://github.com/andy5995/canfigger.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6a1990da902b615052fa6d3b98704b8a0dc1320d7545feb2f9a86d8a9413288a"
    sha256 cellar: :any,                 arm64_sequoia:  "1eea36988f6c7adf32c10b85effe85af3344fd9c294de23c7d3f8b391222c56e"
    sha256 cellar: :any,                 arm64_sonoma:   "d55f2ee425decbb379da3105d48ec055a42b87f72efbffa6a875d53e74faebfb"
    sha256 cellar: :any,                 arm64_ventura:  "ca6dbe2e1c9d8841cf927367e9f472b1fed91d84ada7ac1295e78e7c135f6341"
    sha256 cellar: :any,                 arm64_monterey: "4fa68580783fc78146550db423b46e27004fe2c83ff54135159e750b399f06e5"
    sha256 cellar: :any,                 sonoma:         "ae03386506e951da6525a8c437c62aee6e232ab8a52ab14bcb7c63de103d4903"
    sha256 cellar: :any,                 ventura:        "163c84d05419a4c6f58fbfaa5923ef2bea68a5c7fb8e89bb7080323840ffe6a5"
    sha256 cellar: :any,                 monterey:       "2481309bc1cc7485ae7fca15bcb396498b19a5ef370cb3a71c9e608b8bc16fd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c8f836846182fc7b48b5375c1a69bb771b3ab32f38e4e7dece9c687960cd4739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b3630e0553221aa87402808455550585ca65a0549a6ca12f1c6d1fa85366596"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "-Dbuild_tests=false", "-Dbuild_examples=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.conf").write <<~EOS
      Numbers = list, one , two, three, four, five, six, seven
    EOS

    (testpath/"test.c").write <<~C
      #include <canfigger.h>
      #include <stdio.h>

      int main()
      {
        char *file = "test.conf";
        struct Canfigger *config = canfigger_parse_file(file, ',');

        if (!config)
          return -1;

        while (config != NULL)
        {
          printf("Key: %s, Value: %s\\n", config->key,
                  config->value != NULL ? config->value : "NULL");

          char *attr = NULL;
          canfigger_free_current_attr_str_advance(config->attributes, &attr);
          while (attr)
          {
            printf("Attribute: %s\\n", attr);

            canfigger_free_current_attr_str_advance(config->attributes, &attr);
          }

          canfigger_free_current_key_node_advance(&config);
          putchar('\\n');
        }

        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lcanfigger", "-o", "test"
    assert_match <<~EOS, shell_output("./test")
      Key: Numbers, Value: list
      Attribute: one
      Attribute: two
      Attribute: three
      Attribute: four
      Attribute: five
      Attribute: six
      Attribute: seven
    EOS
  end
end
