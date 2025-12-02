class Libsass < Formula
  desc "C implementation of a Sass compiler"
  homepage "https://github.com/sass/libsass"
  url "https://github.com/sass/libsass.git",
      tag:      "3.6.6",
      revision: "7037f03fabeb2b18b5efa84403f5a6d7a990f460"
  license "MIT"
  head "https://github.com/sass/libsass.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ed01028a87ef04e5dd829f40013f3db3cff5317e1cb0ee3f7ac9de135281cb61"
    sha256 cellar: :any,                 arm64_sequoia:  "d5f0835bddfab893cf537c1cb10f42a6abbaa04100954223de905a7f3879a581"
    sha256 cellar: :any,                 arm64_sonoma:   "a5262b92c5ef6c48e579002e9705e33a4e69c47ba9004ac9b13843506f314e8f"
    sha256 cellar: :any,                 arm64_ventura:  "f16e4b941d9f7b15af8126904348ff2c82a486a08c358827518a35a341b9954e"
    sha256 cellar: :any,                 arm64_monterey: "0a025c9fa92be85ae22f55df1e2c0cdd4536ef648fd4343a5c20077557276241"
    sha256 cellar: :any,                 sonoma:         "cf3dc9646ee1c1de9fbb48df62623c02267d77ca3fda6c78a9acc7b893387ec9"
    sha256 cellar: :any,                 ventura:        "aa2acc65e1a7804b8df89f73a9c649b30487a4c0a42e08b45a184a4f727c9c86"
    sha256 cellar: :any,                 monterey:       "ed5dd1003cce5b3d47138cb192f4018482e381e6b18d4b63a980fb2400bf737c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8b569c57c1429048b0e8d3c3f4e15bc6f9b9efc3943cdaa6a9e6f7d891f59750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "091841d5a1c742f6574ef14d6bb952d54409c7fcbc2085222a11b18eee0e38ba"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.cxx11
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    # This will need to be updated when devel = stable due to API changes.
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lsass"
    system "./test"
  end
end
