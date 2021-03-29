class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.4.0.tar.gz"
  sha256 "a185b4f3fd9d371e5f5cb6aad0a9a495f3015539a89672158ccc863ebdd5b7d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fe792c337a90a0ebd45b7a572f17dbefac53216cdf62a24f5bf50581cf785389"
    sha256 cellar: :any, big_sur:       "6bc61d0fe7163f008b39d5c4deed828c51cbf2de2defc850da29f7fcf254747e"
    sha256 cellar: :any, catalina:      "8ca8c7dd4d37cdf3ad84cdfa4974628fae38c519c693aa0463fe170eb31ab952"
    sha256 cellar: :any, mojave:        "fdc2e182d931346481e77177a6effb3448ea6baf8f668db674e104f02d41941a"
  end

  depends_on "autoconf" => :build
  depends_on "gmp" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "libev"
  depends_on "pcre"

  uses_from_macos "m4"
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
