class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://github.com/libconfuse/libconfuse"
  url "https://github.com/libconfuse/libconfuse/releases/download/v3.3/confuse-3.3.tar.xz"
  sha256 "1dd50a0320e135a55025b23fcdbb3f0a81913b6d0b0a9df8cc2fdf3b3dc67010"
  license "ISC"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "8c9faf9f2e1e5d1d0745acf79b46347b499053b9bcba4e4f4f89296bd5f8aad3"
    sha256 cellar: :any, arm64_sequoia:  "4a559294bf3ec51132b479ee9b90c5e90dea6183c11707471b89a4d06b0ab371"
    sha256 cellar: :any, arm64_sonoma:   "6d46500c283c20fcf41348fc34293d30a85e0fac9955ea849369deeaf84b3a2b"
    sha256 cellar: :any, arm64_ventura:  "1c7aa3d075082f2742747ac5034f60c90b448c694ccc5b3330b71f1afdd81f81"
    sha256 cellar: :any, arm64_monterey: "633330ab55c7992ac1a9dcb3d990029d1445aab0d3e5c3a8c5759af2554b33d4"
    sha256 cellar: :any, arm64_big_sur:  "1eeec2cb7b54cf11c1e13448f191ed97d4f2477c215130b6402256678019f36e"
    sha256 cellar: :any, sonoma:         "38fa9c049ceed5cb948bb4c113f0c394a713873cb942f9e3ff97b6e40730927d"
    sha256 cellar: :any, ventura:        "5a520e7ca6ac3a7260b385c7e47cb144f888df00125a9300647b29abe4a732e9"
    sha256 cellar: :any, monterey:       "bcdcdab60caa250aa1a5b38346dda7bd0a88ffb6359d73d8fab8aa046d5bc2fe"
    sha256 cellar: :any, big_sur:        "370cd5df07249d44cbf0a848001be19d41341f404d229dcdcb3b5ae6ead4300c"
    sha256 cellar: :any, catalina:       "13ad01ca606e746ab7f6bcd42b0da08abdcc29ccaaa9e8106f9d28bfe96bffd7"
    sha256               arm64_linux:    "0be4562183f1ec990e0a9f2e082e82528048a0261b292013a8fc5b3f06e4b7db"
    sha256               x86_64_linux:   "a5fbe815c75f10344684dab03501ecab39cec4b157e46d955f6e2c70062d120b"
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
