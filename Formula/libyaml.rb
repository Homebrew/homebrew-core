class Libyaml < Formula
  desc "YAML Parser"
  homepage "https://github.com/yaml/libyaml"
  url "https://github.com/yaml/libyaml/archive/0.2.3.tar.gz"
  sha256 "e36ec947f89725e90e062eca39a8a8c88fdce4f83315ab942aa896627236421e"

  bottle do
    cellar :any
    sha256 "63cf355fb4b9fb7e33cb9d0b9b366252f680d887cb5d7e12de8468381aa5f000" => :catalina
    sha256 "aa23980d03fe5bd2e60d59424061b7ac91c24f315de84ec33856ab3bf44de0af" => :mojave
    sha256 "b763aa33bfdf6dca21b3bc16919217939ec28916266bb476ff8f44e777bde176" => :high_sierra
    sha256 "35d27c9b0709f142d5d30a2d37566d85dafcd023f64016d042282eeaf94102b7" => :sierra
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
