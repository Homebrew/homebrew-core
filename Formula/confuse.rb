class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://github.com/martinh/libconfuse"
  url "https://github.com/martinh/libconfuse/releases/download/v3.2.1/confuse-3.2.1.tar.xz"
  sha256 "23c63272baf2ef4e2cbbafad2cf57de7eb81f006ec347c00b954819824add25e"

  bottle do
    cellar :any
    sha256 "8c29700bcc44c546f23ac16e0b5d1b49077958b7deb73ff1b9172519a9f5a33a" => :sierra
    sha256 "4124552d3f6fe5ffd0f21b9c85ee9eb39577df3909387ff9816748fc71d91734" => :el_capitan
    sha256 "364eece5ee7260679ff9a09166d203b2b423e0287b1f360f4f7756386ef71e96" => :yosemite
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
