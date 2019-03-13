class Libyaml < Formula
  desc "YAML Parser"
  homepage "https://github.com/yaml/libyaml"
  url "https://github.com/yaml/libyaml/archive/0.2.2.tar.gz"
  sha256 "46bca77dc8be954686cff21888d6ce10ca4016b360ae1f56962e6882a17aa1fe"

  bottle do
    cellar :any
    sha256 "75e21c4d4b49696e527ab91b7af6f061e844b10b7de99e6019724dbaa0fe04f9" => :mojave
    sha256 "8771eba64f60fea66813d1e373606ddd9333e3731f51e36a1fc8ea780610015d" => :high_sierra
    sha256 "376cfe0eb3328d5446f3621ee7eae39fdf8a7c25155bdfa399aacb903eecf40b" => :sierra
    sha256 "24656930e8eeadd31f07b75aede75aa186dae9e3f122598535d93a7feff61384" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <yaml.h>

      int main()
      {
        yaml_parser_t parser;
        yaml_parser_initialize(&parser);
        yaml_parser_delete(&parser);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lyaml", "-o", "test"
    system "./test"
  end
end
