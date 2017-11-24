class Libsass < Formula
  desc "C implementation of a Sass compiler"
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass.git",
      :tag => "3.4.7",
      :revision => "c943792a6e64468b66f226504a47a8160cbd2d08"
  head "https://github.com/sass/libsass.git"

  bottle do
    cellar :any
    sha256 "2c435ac0bd3e9e6c93cf7ee6393c832ebab03632587100509af598ea8114b22a" => :high_sierra
    sha256 "579f25eb99112b3e4bfbc69ce529a703fefa5e6607dab0b42d4888f848190ebb" => :sierra
    sha256 "cfea481ac59c31b441bdb03db11afb5e2af55db6d3468d3aaf7b2d825fe6c1c1" => :el_capitan
    sha256 "d9943c309ba1454a4275e262ea03d7c68e843d54eb89cbcbd9160b9e215c6ee8" => :yosemite
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
