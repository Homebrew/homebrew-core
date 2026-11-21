require File.expand_path("../../Abstract/portable-formula", __dir__)

class PortableLibyaml < PortableFormula
  desc "YAML Parser"
  homepage "https://github.com/yaml/libyaml"
  url "https://github.com/yaml/libyaml/releases/download/0.2.6/yaml-0.2.6.tar.gz"
  sha256 "43b393a117bd4fe39812fddc94e3d654359a3ae05653dcf0110a1122d1747e61"
  license "MIT"
  compatibility_version 1

  livecheck do
    formula "libyaml"
  end

  deny_network_access!

  def install
    system "./configure", *portable_configure_args,
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static",
                          "--disable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <yaml.h>

      int main()
      {
        yaml_parser_t parser;
        yaml_parser_initialize(&parser);
        yaml_parser_delete(&parser);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lyaml", "-o", "test"
    system "./test"
  end
end
