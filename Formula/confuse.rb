class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://github.com/martinh/libconfuse"
  url "https://github.com/martinh/libconfuse/releases/download/v3.0/confuse-3.0.tar.xz"
  sha256 "bb75174e02aa8b44fa1a872a47beeea1f5fe715ab669694c97803eb6127cc861"

  bottle do
    cellar :any
    sha256 "7ac949e802fef398b1b6a36e3c66e1f15f218dc71f1a9a925d9961fca676e659" => :sierra
    sha256 "bccc3cbebb15df2eddeb4167924e691d02ebdf8c92e91f18d11bcd3aa2d6fed8" => :el_capitan
    sha256 "1e354b584efd29bed60120d9979fd796ff7f0070881f8c38683b940480150f7c" => :yosemite
    sha256 "25662250293bb36d1c3fb99bca9a4b3ece7f9857e5ffdfa59dad5e627fcf15c4" => :mavericks
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
    system ENV.cc, "test.c", "-lconfuse", "-o", "test"
    assert_match /world/, shell_output("./test")
  end
end
