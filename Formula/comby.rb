class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.4.1.tar.gz"
  sha256 "0b1b674116c269d522c588ae36c332c7f4302e4f6216aefd7b0eec15e2c3016c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a9df56b11dc6635ed691bf38d5cc1b39ffb2b9f7c3933516ad6b62d0907e48f0"
    sha256 cellar: :any, big_sur:       "187c14fa6312f3ff02334c10fc6f1b593820e239b4491500ee789bc07ee2b3ef"
    sha256 cellar: :any, catalina:      "fca67fa512a6e494718e9cf700628e241ec5ea30b16357962533e83417d2940c"
    sha256 cellar: :any, mojave:        "21927cdbae2884c83fecd4f33715238ae8f78e3bd1dd4262251e7ac4f3de1813"
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
