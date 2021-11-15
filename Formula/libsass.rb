class Libsass < Formula
  desc "C implementation of a Sass compiler"
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass.git",
      tag:      "3.6.5",
      revision: "f6afdbb9288d20d1257122e71d88e53348a53af3"
  license "MIT"
  head "https://github.com/sass/libsass.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2117b0fa30facdc407537232daa889995d87ce5f4988163017f62ed56580b32b"
    sha256 cellar: :any,                 arm64_big_sur:  "22ecfef684130e0eb31c60574970b5549d4d17eca862304b4603f2ced11e01cb"
    sha256 cellar: :any,                 monterey:       "072b22e5429cc1e86436667ccd5ea3353c10162f3523ede8534b7ba58e6b5d11"
    sha256 cellar: :any,                 big_sur:        "6b898ecf23182d8510c20cc39f983ff1d032d05f782a860a8bf4f7268144bc8a"
    sha256 cellar: :any,                 catalina:       "d3ed514cda1f654bba381f40cefeae9af3dc72b9299a3b55afe08165811eacd6"
    sha256 cellar: :any,                 mojave:         "3300df2def4e03dc12a86fca52cd7555c8ce42320cfaf2d143d27129cd4e8bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af3237dcac2845cc667ade463821e1ffed5048419786c99133e10f868b6a33ed"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
