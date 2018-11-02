class Libsass < Formula
  desc "C implementation of a Sass compiler"
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass.git",
      :tag      => "3.5.4",
      :revision => "1e52b74306b7d73a617396c912ca436dc55fd4d8"
  head "https://github.com/sass/libsass.git"

  bottle do
    cellar :any
    sha256 "7168ae526553313df04fe97200a079e67cb086552b7aada4b34294af8c3ea519" => :mojave
    sha256 "6264a337eee7d1ebcf58df8040f4c84bdde0e94e863f6f7c08522b475ada6d68" => :high_sierra
    sha256 "a544a47112dc4774528288db9373c1489500e82a5afd68c05c57fe5d7ab5e269" => :sierra
    sha256 "eb7f2898f0027eec8f37d3e51d9b18e84215b6d1f8c5c1e7bdb9f85d5922fc5d" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  needs :cxx11

  def install
    ENV.cxx11
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # This will need to be updated when devel = stable due to API changes.
    (testpath/"test.c").write <<~EOS
      #include <sass/context.h>
      #include <string.h>

      int main()
      {
        const char* source_string = "a { color:blue; &:hover { color:red; } }";
        struct Sass_Data_Context* data_ctx = sass_make_data_context(strdup(source_string));
        struct Sass_Options* options = sass_data_context_get_options(data_ctx);
        sass_option_set_precision(options, 1);
        sass_option_set_source_comments(options, false);
        sass_data_context_set_options(data_ctx, options);
        sass_compile_data_context(data_ctx);
        struct Sass_Context* ctx = sass_data_context_get_context(data_ctx);
        int err = sass_context_get_error_status(ctx);
        if(err != 0) {
          return 1;
        } else {
          return strcmp(sass_context_get_output_string(ctx), "a {\\n  color: blue; }\\n  a:hover {\\n    color: red; }\\n") != 0;
        }
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lsass"
    system "./test"
  end
end
