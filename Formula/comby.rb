class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.2.2.tar.gz"
  sha256 "1d3b25bbbd7bceab979241773f08df09e284df3aa6d7f8abe323df7e1f8dbcd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1d0873b8068d55369ea2d6ac9eedc57c4194c7d3d338868e1f1998e6acdd62e4"
    sha256 cellar: :any, big_sur:       "39b679a2e0bd88cb8e9d5daab0266d3315ea232f8113cbf7c2e61b94e0b7a2c5"
    sha256 cellar: :any, catalina:      "883fe43536080c4bfc202948dbcb8d9d667c1ed58931d48f37f331d4886388fb"
    sha256 cellar: :any, mojave:        "f0c55be9ecc4559b6a0c95fa8550f9c7c065130411d3fcca9504f38a81230d19"
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
