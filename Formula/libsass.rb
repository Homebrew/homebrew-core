class Libsass < Formula
  desc "C implementation of a Sass compiler"
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass.git",
      :tag => "3.4.7",
      :revision => "c943792a6e64468b66f226504a47a8160cbd2d08"
  head "https://github.com/sass/libsass.git"

  bottle do
    cellar :any
    sha256 "3a38c1dc4c4d22016ca3a2908fcf5419d5c042e7de1ffec14265f289f5c33c81" => :high_sierra
    sha256 "2ab2f58d67ae7e9c96f4108e9ec8a2b096fbe8082e608518cb78eb3a560817f9" => :sierra
    sha256 "43f6be0ecbcec34921e9f4b687e6b344124dc59ce47c2d64b52ef9380e89c2ad" => :el_capitan
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
