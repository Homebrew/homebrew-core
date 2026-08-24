class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://www.nongnu.org/confuse/manual/"
  url "https://github.com/libconfuse/libconfuse/releases/download/v3.4/confuse-3.4.tar.xz"
  sha256 "36bfa3928f9c323914c7c8317e8722cb22f41db69d7c9d4c24b4689fa955445d"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9587a497f55f655fc94c7a357b9d8f6d407def51af0dbf35f18f2defe57941e9"
    sha256 cellar: :any, arm64_sequoia: "324a29d5b8b347ba4d9fbbe1b6ef51eb73ed617ca4431f7a062f700f88844849"
    sha256 cellar: :any, arm64_sonoma:  "16010e11c9d699f59e95ca4015d1b172ef73e2b3079b6ecf79c9906f3a518e7b"
    sha256 cellar: :any, sonoma:        "a4c60fe46c2aaf8b9438c59d937e05b2556a192a6af8bae78837831517b86845"
    sha256               arm64_linux:   "0711b0b1f3835647a373caecdc3fd8fd78f053762bbefe120f9c111f62eabb01"
    sha256               x86_64_linux:  "4ab3a2a1553f0668be4ac29102476e58dcba2d1945c24bbcb1050f09bce1649e"
  end

  depends_on "pkgconf" => :build

  def install
    system "./configure", *std_configure_args
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lconfuse", "-o", "test"
    assert_match "world", shell_output("./test")
  end
end
