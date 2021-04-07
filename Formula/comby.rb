class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.4.1.tar.gz"
  sha256 "0b1b674116c269d522c588ae36c332c7f4302e4f6216aefd7b0eec15e2c3016c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1dceabb44939d94972947dbf2c9988b23515e7eeae7290a10d9bffc404f23417"
    sha256 cellar: :any, big_sur:       "d7d6594d602e2915555348fb589f2058f06d64e00a73e907403dced46cc7ffc6"
    sha256 cellar: :any, catalina:      "1c663b0660231ea560507749361beb8db0aea8930bdb927ef6746b10f45d5af6"
    sha256 cellar: :any, mojave:        "0ac0b452387c51fc5d09309a42a5628af613f4b04fb1c0c5abd8eb967e28fbb0"
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
