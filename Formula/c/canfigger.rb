class Canfigger < Formula
  desc "Simple configuration file parser library"
  homepage "https://github.com/andy5995/canfigger/"
  url "https://github.com/andy5995/canfigger/releases/download/v0.3.2/canfigger-0.3.2.tar.xz"
  sha256 "f128a62cec50cce16e1e8c87012f8564d972b663316b27358d1d7f6b4486bec8"
  license "MIT"
  head "https://github.com/andy5995/canfigger.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13a1c0f9dc12a5ab24bb8135873296b386a9a2550adb8c70ca2baa62035b5e68"
    sha256 cellar: :any,                 arm64_sequoia: "0f6c11ffa385f60746737a34ad1e358b05a5695244d6a7764309a5d11617a671"
    sha256 cellar: :any,                 arm64_sonoma:  "e89a075bcb14bd0e42811ba36699c3418eae2538631fa0ee3473712c5a5cd913"
    sha256 cellar: :any,                 sonoma:        "a25520c1a99e0d88ac2449d30daadfb00c95837466b4ec9678aaa449d38e6894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2aedd0fc386f76944c4d383b849e5a4f670330ecf9d13c454ae2c9a79082bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "961162137d888c0bc94b2fa6573d35c68429d50262a02be47a5a7d2573df7f7f"
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
      #include <canfigger/canfigger.h>
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
