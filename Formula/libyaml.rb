class Libyaml < Formula
  desc "YAML Parser"
  homepage "https://github.com/yaml/libyaml"
  url "https://github.com/yaml/libyaml/archive/0.2.1.tar.gz"
  sha256 "1d2aeb87f7d317f1496e4c39410d913840714874a354970300f375eec9303dc4"

  bottle do
    cellar :any
    sha256 "1b44e5e2bc63def5c491b74d6a3538913690c126e071d95081d5ec06d436db48" => :high_sierra
    sha256 "697f644d61983bd75f1ff5e7d4cccce26cc9a81cb8c78c066931dfc7c0dc94ba" => :sierra
    sha256 "ad9d3bee24a05281ecccd88dba5ac246cf27b99f32161b3572c109993c75238e" => :el_capitan
    sha256 "3a7788655c3c8f3b7ad73521928277ca5433789e134f437534702145171b1104" => :yosemite
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
