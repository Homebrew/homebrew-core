class Libsass < Formula
  desc "C implementation of a Sass compiler"
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass.git", :tag => "3.3.6", :revision => "3ae9a2066152f9438aebaaacd12f39deaceaebc2"
  head "https://github.com/sass/libsass.git"

  bottle do
    cellar :any
    sha256 "f1b5ce82f6e885c5ceca970c72f1707641d30aaae1614bcc6d9608a3c0f0bf56" => :sierra
    sha256 "dda76f52e1804320e6bbd44f4fd6e8f5b68a97321ce9fd099b9d58c22c88f25b" => :el_capitan
    sha256 "5a53801da164f057777551c030c2266db876ea109e9dba9addde3899b6143c7b" => :yosemite
    sha256 "db89145686bfab97c2736b6a6a8cd129c9323091b4e7f12f5af55ec2443575f9" => :mavericks
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
    (testpath/"test.c").write <<-EOS.undent
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
    system ENV.cc, "-o", "test", "test.c", "-lsass"
    system "./test"
  end
end
