class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.6.0.tar.gz"
  sha256 "bd288ff606f972f9bf2bfb14d967731ff5dd8358d4f2bba7ab4cdc65273cd7bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7f5a5449b0bd8222feb40f6ca4ee78926b41edc0633747b7055930ae33199bac"
    sha256 cellar: :any, big_sur:       "5200c167a04e1ceb32acf47f8b3a22a05d6a972dd96d2c972697b7b8d9537772"
    sha256 cellar: :any, catalina:      "eb96f282f03bb2faa31b1bb9583211f2225d1de7606d830e7e8a7485c642ec69"
    sha256 cellar: :any, mojave:        "4bc044f302385e367e43b214aa3da7cd660bf28f5069aab6b2f5fabed5894ed1"
  end

  depends_on "autoconf" => :build
  depends_on "gmp" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libev"
  depends_on "pcre"

  uses_from_macos "m4"
  uses_from_macos "sqlite"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize
    opamroot = buildpath/".opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--no-setup", "--disable-sandboxing"
    system "opam", "config", "exec", "--", "opam", "install", ".", "--deps-only", "-y"

    ENV.prepend_path "LIBRARY_PATH", opamroot/"default/lib/hack_parallel" # for -lhp
    system "opam", "config", "exec", "--", "make", "release"

    bin.install "_build/default/src/main.exe" => "comby"
  end

  test do
    expect = <<~EXPECT
      --- /dev/null
      +++ /dev/null
      @@ -1,3 +1,3 @@
       int main(void) {
      -  printf("hello world!");
      +  printf("comby, hello!");
       }
    EXPECT

    input = <<~INPUT
      EOF
      int main(void) {
        printf("hello world!");
      }
      EOF
    INPUT

    match = 'printf(":[1] :[2]!")'
    rewrite = 'printf("comby, :[1]!")'

    assert_equal expect, shell_output("#{bin}/comby '#{match}' '#{rewrite}' .c -stdin -diff << #{input}")
  end
end
