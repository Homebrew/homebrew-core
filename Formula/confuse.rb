class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://github.com/martinh/libconfuse"
  url "https://github.com/martinh/libconfuse/releases/download/v3.2.1/confuse-3.2.1.tar.xz"
  sha256 "23c63272baf2ef4e2cbbafad2cf57de7eb81f006ec347c00b954819824add25e"

  bottle do
    cellar :any
    sha256 "59cc0b7f7203045e2ee4f65c3318463bfd7eee373418fb096358db81591df64b" => :sierra
    sha256 "8d4b5d0523049f6a836734df05e1a7a596c8a3b9139b45603513598e19e55cb5" => :el_capitan
    sha256 "0eecb39714d5032b2e87adad8e254c14439a0325ccb3914058f9638df1da8563" => :yosemite
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
