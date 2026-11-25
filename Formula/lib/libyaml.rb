class Libyaml < Formula
  desc "YAML Parser"
  homepage "https://github.com/yaml/libyaml"
  url "https://github.com/yaml/libyaml/archive/refs/tags/0.2.7.tar.gz"
  sha256 "7f76964485c67dc4e1537fdfd4ad5c8772bcef501c5451b617e43f831034994e"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "ee50683c383d0fc75186f4331913f85acd97e3501e46c1ceb651018cb827ec0c"
    sha256 cellar: :any, arm64_golden_gate: "af43cbb6cfc13515a520e8491b9a7e8a73fdac42a5a45f53e7c803eb3c99dcb5"
    sha256 cellar: :any, arm64_tahoe:       "ccfa9b03cc309ee805fe13767172a1fb1698cbdda862919a883cdf052c60cb48"
    sha256 cellar: :any, arm64_sequoia:     "a31294e0c9b02c3388c5b1b75c81074a1babb3a5c8663e350572012866e7ac54"
    sha256 cellar: :any, arm64_linux:       "8780be35726cbfe7f35e5861848fb011f6c838860ecaf42520ef7c33afc3cba4"
    sha256 cellar: :any, x86_64_linux:      "106d554ac52de1b20030a834fdcf383671c7a2619eeebb84b722c2518729d5d8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  deny_network_access!

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lyaml", "-o", "test"
    system "./test"
  end
end
