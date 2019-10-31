class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/0.10.0.tar.gz"
  sha256 "081633c100ca6696760e21bd3decd01666c9ad4946b370dc90412e55a324435e"

  depends_on "gmp" => :build
  depends_on "opam" => :build
  depends_on "pcre"
  depends_on "pkg-config"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize
    opamroot = buildpath/".opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--no-setup", "--disable-sandboxing", "--compiler=4.09.0", "--jobs=1"
    system "opam", "config", "exec", "--", "opam", "install", ".", "--deps-only", "-y"
    system "opam", "config", "exec", "--", "make", "release"
    bin.install "_build/default/src/main.exe" => "comby"
  end

  test do
    assert_equal "0.10.0", shell_output("#{bin}/comby -version").strip

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
