class Canfigger < Formula
  desc "Simple configuration file parser library"
  homepage "https://github.com/andy5995/canfigger/"
  url "https://github.com/andy5995/canfigger/releases/download/v0.3.1/canfigger-0.3.1.tar.xz"
  sha256 "8ecb23692b2fdfd8f2f8f22bacf07ab7976915fd157692920c28400caa6aa1bf"
  license "MIT"
  head "https://github.com/andy5995/canfigger.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2783d1ab89eb7929acc3d8ab9ba99c232f0f7d83a6fdcea6679ff28fac5727cb"
    sha256 cellar: :any,                 arm64_sequoia: "b22c284f204b00392945429c4b960d7187ef2320010e87c77394d7c5e7fb349a"
    sha256 cellar: :any,                 arm64_sonoma:  "9f34ac6b55913b3b31fee5b6292da93186020b66bf04d69b8072c36f91588ed6"
    sha256 cellar: :any,                 sonoma:        "79c9d4b14069056c12d285aa5ec0d58534bf6dd662b68d538ce5a7913a0283d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d3f262bccf48f54a2d488399d949f0521d85187ce43c328cacd75db354a5af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e96d150674a7cd65055737d5caa4cb5a7b8cc27618e02837fd570979e2cf1bd"
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
