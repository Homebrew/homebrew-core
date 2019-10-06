class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://github.com/martinh/libconfuse"
  url "https://github.com/martinh/libconfuse/releases/download/v3.2.2/confuse-3.2.2.tar.xz"
  sha256 "a9240b653d02e8cfc52db48e8c4224426e528e1faa09b65e8ca08a197fad210b"

  bottle do
    cellar :any
    sha256 "349c7123642a12a49e387edaf7b8548d0bfa43a459960bf086e82d5b8b148b98" => :catalina
    sha256 "24e05e5b2e29feab1222d9087e064349131023b97b3e5b8f847c8babe968cea2" => :mojave
    sha256 "6e5f40a3ca684e8aeef00fe121a0742214a434d23ed45810d0b7b6c1e5ff65ac" => :high_sierra
    sha256 "8a34f5dee392fb5c572df1e636821b1b6af62a197aca7a2de0c49b4f55bb2874" => :sierra
    sha256 "8547a54095de338b895476e8fc2cfabc27ed9039996f37bdcb48040759c67f79" => :el_capitan
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <confuse.h>
      #include <stdio.h>

      cfg_opt_t opts[] =
      {
        CFG_STR("hello", NULL, CFGF_NONE),
        CFG_END()
      };

      int main(void)
      {
        cfg_t *cfg = cfg_init(opts, CFGF_NONE);
        if (cfg_parse_buf(cfg, "hello=world") == CFG_SUCCESS)
          printf("%s\\n", cfg_getstr(cfg, "hello"));
        cfg_free(cfg);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lconfuse", "-o", "test"
    assert_match /world/, shell_output("./test")
  end
end
