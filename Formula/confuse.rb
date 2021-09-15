class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://github.com/libconfuse/libconfuse"
  url "https://github.com/libconfuse/libconfuse/releases/download/v3.3/confuse-3.3.tar.xz"
  sha256 "1dd50a0320e135a55025b23fcdbb3f0a81913b6d0b0a9df8cc2fdf3b3dc67010"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1eeec2cb7b54cf11c1e13448f191ed97d4f2477c215130b6402256678019f36e"
    sha256 cellar: :any, big_sur:       "370cd5df07249d44cbf0a848001be19d41341f404d229dcdcb3b5ae6ead4300c"
    sha256 cellar: :any, catalina:      "13ad01ca606e746ab7f6bcd42b0da08abdcc29ccaaa9e8106f9d28bfe96bffd7"
    sha256 cellar: :any, mojave:        "d6038fe2a7fcfea4ba6e3c29174cb6201ce7d05e22ef4c76b881b9f12dabcff6"
    sha256 cellar: :any, high_sierra:   "371f699488d7e4459251c55e4ef4d9087b08e07b4fedfc553476bc30070ca9c1"
    sha256               x86_64_linux:  "a5fbe815c75f10344684dab03501ecab39cec4b157e46d955f6e2c70062d120b"
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
    assert_match "world", shell_output("./test")
  end
end
