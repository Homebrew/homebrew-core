class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://github.com/martinh/libconfuse"
  url "https://github.com/martinh/libconfuse/releases/download/v3.1/confuse-3.1.tar.xz"
  sha256 "8171f31e0071d5e4460269fdcc8b4e748cf23b4bf6bbe672f718a136dd63ca66"

  bottle do
    cellar :any
    sha256 "d9e6e9716101784e7ae8eed5b3ec1904fe2567a23dcf67bf9135a5b6d997bf40" => :sierra
    sha256 "d43580d707a754cce473091b4c0ca5ef02132511d8bccfcb56d24e057ff7dace" => :el_capitan
    sha256 "defb5657f4a190f8f5d59a1508273454fae4c3c6c93c7365b97ad39475f8967a" => :yosemite
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
