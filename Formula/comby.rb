class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/0.11.0.tar.gz"
  sha256 "4bd35595793bb7ee3f01d406e83d218cef01929a95388a343077b9937c541a94"

  bottle do
    cellar :any
    sha256 "80eeffb4dbda20a3018af1863353a44628bad2eadefe705c192a176625396c8e" => :catalina
    sha256 "7b3b29f0c2f32cea7abb9c53def46b0bd789084ace16053107f713324b621e3c" => :mojave
    sha256 "a1aaaf88033a2f107a8ae36372c31da875d509b823aa1f68278174e95013812c" => :high_sierra
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
    assert_equal "0.11.0", shell_output("#{bin}/comby -version").strip

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
