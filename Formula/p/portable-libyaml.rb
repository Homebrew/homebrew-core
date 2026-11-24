require File.expand_path("../../Abstract/portable-formula", __dir__)

class PortableLibyaml < PortableFormula
  desc "YAML Parser"
  homepage "https://github.com/yaml/libyaml"
  url "https://github.com/yaml/libyaml/releases/download/0.2.7/yaml-0.2.7.tar.gz"
  sha256 "0c39256b8be0fc689f5c7bfdea1bc9f3fb1fd648468fd3cc6fd375e09ffb6f13"
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
