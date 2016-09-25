class Libyaml < Formula
  desc "YAML Parser"
  homepage "http://pyyaml.org/wiki/LibYAML"
  url "http://pyyaml.org/download/libyaml/yaml-0.1.7.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/liby/libyaml/libyaml_0.1.7.orig.tar.gz"
  sha256 "8088e457264a98ba451a90b8661fcb4f9d6f478f7265d48322a196cec2480729"

  bottle do
    cellar :any
    sha256 "e70b72f2e3e07f352421b27d28fd40a1aff6f35327b5ffb2f8b9a9907098a78b" => :sierra
    sha256 "557b32dbf6e6798972e6f9594a91cca044f90f92f410e0eb3ebcbee199f781aa" => :el_capitan
    sha256 "f3c705e4f5790e6340f9c673100a855b16b4603821d711dedf7b2b07e30dfe18" => :yosemite
    sha256 "dcf99044b9c72eb2c1a1017fdbd9020e48f26dc3d9bd7d88aa497b98fdbccd96" => :mavericks
    sha256 "7339f312e5b9011acd518b2bee0008439be8bbd697fe4f4944ea3a2137a41652" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <yaml.h>

      int main()
      {
        yaml_parser_t parser;
        yaml_parser_initialize(&parser);
        yaml_parser_delete(&parser);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lyaml", "-o", "test"
    system "./test"
  end
end
