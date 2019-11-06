class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/0.10.0.tar.gz"
  sha256 "081633c100ca6696760e21bd3decd01666c9ad4946b370dc90412e55a324435e"

  bottle do
    cellar :any
    sha256 "ea3cbad9e3c7706bfe841c5bdc44a3e43514e8fa860a3097731aebe67a4f339a" => :catalina
    sha256 "6b8dc81e1c2c6fc901301b12935acd24584e36f4e14a265c3594fdbbb70a78d7" => :mojave
    sha256 "881acdce34bda5a69cafa4473240ff4b9d9533544fde801a19c09b0c176ab37e" => :high_sierra
  end

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
