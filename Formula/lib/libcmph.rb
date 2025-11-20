class Libcmph < Formula
  desc "C minimal perfect hashing library"
  homepage "https://cmph.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cmph/v2.0.2/cmph-2.0.2.tar.gz"
  sha256 "365f1e8056400d460f1ee7bfafdbf37d5ee6c78e8f4723bf4b3c081c89733f1e"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "795cbd543a01cc09b16b32cd349b2c41ecf49511ec8dd413c9c992e044a7d1a0"
    sha256 cellar: :any,                 arm64_sequoia:  "43f6a25f51d2e29fc992882901b8fae82353d80efe71305bc6acf5bd852ff6c7"
    sha256 cellar: :any,                 arm64_sonoma:   "72be852d28eec60c8526c263938023f4eb33dfd58edbbcd77b33d1e319816f82"
    sha256 cellar: :any,                 arm64_ventura:  "dc5c4b140ee2e3ed459271e26f0fc47b9294626fbcad98a86d6326593a2ca764"
    sha256 cellar: :any,                 arm64_monterey: "85743179d6c3127e57f41d11b451f708a653b3b033e1b725b30fa0c1c6712b9e"
    sha256 cellar: :any,                 arm64_big_sur:  "30d22ddad3521ec07248910864e8caae7f8d959597663a9d21d2447c56e6639c"
    sha256 cellar: :any,                 sonoma:         "05fc67c97082d41ca49ab0819e8c385fff73d953877ab6cd0d6b8fcd0a8c6467"
    sha256 cellar: :any,                 ventura:        "c839119e4df7eb3ac96d33dd388c25000bece07e3b74ce9caa4ff3867ec54b07"
    sha256 cellar: :any,                 monterey:       "248ea1c47707f4baf30f540f50803e1f3678ebaf5c80215ed4871f96cf77b314"
    sha256 cellar: :any,                 big_sur:        "f1cc2211ac56a2702405246535a55613855c3879885ca73aa65d76890c2aa0e5"
    sha256 cellar: :any,                 catalina:       "c38019c153c728a28acbfe340cc86764285ec24edbdba5234b0593f83d355c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "09b7ae4a3fe814126fff575f57ba2cfac5599eb86cded4d810ae777d2e4c229e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b4a556fa47365d3ebf9312acddf3fc64921094161bd6d6e1bcda3df92be70cd"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <cmph.h>
      #include <string.h>
      #include <stdio.h>
      int main(int argc, char **argv)
      {
          unsigned int i = 0;
          const char *vector[] = {"aaaaaaaaaa", "bbbbbbbbbb", "cccccccccc", "dddddddddd", "eeeeeeeeee",
              "ffffffffff", "gggggggggg", "hhhhhhhhhh", "iiiiiiiiii", "jjjjjjjjjj"};
          unsigned int nkeys = 10;
          FILE* mphf_fd = fopen("temp.mph", "w");
          cmph_io_adapter_t *source = cmph_io_vector_adapter((char **)vector, nkeys);
          cmph_config_t *config = cmph_config_new(source);
          cmph_config_set_algo(config, CMPH_BRZ);
          cmph_config_set_mphf_fd(config, mphf_fd);
          cmph_t *hash = cmph_new(config);
          cmph_config_destroy(config);
          cmph_dump(hash, mphf_fd);
          cmph_destroy(hash);
          fclose(mphf_fd);
          mphf_fd = fopen("temp.mph", "r");
          hash = cmph_load(mphf_fd);
          while (i < nkeys) {
              const char *key = vector[i];
              unsigned int id = cmph_search(hash, key, (cmph_uint32)strlen(key));
              fprintf(stdout, "%s %u\\n", key, id);
              i++;
          }
          cmph_destroy(hash);
          cmph_io_vector_adapter_destroy(source);
          fclose(mphf_fd);
          return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcmph", "-o", "test"
    output = shell_output(testpath/"test").lines
    assert_equal 10, output.length
    letters = output.map { |line| line.split.first }
    numbers = output.map { |line| line.split.last.to_i }
    ("a".."j").each { |letter| assert_equal 1, letters.count(letter * 10) }
    (0..9).each { |i| assert_equal 1, numbers.count(i) }
  end
end
