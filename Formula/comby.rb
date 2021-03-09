class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.2.2.tar.gz"
  sha256 "1d3b25bbbd7bceab979241773f08df09e284df3aa6d7f8abe323df7e1f8dbcd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b3432a0972c8f0d912e68f15e824ba179358912878bbd3b3cdf677c87a65376b"
    sha256 cellar: :any, big_sur:       "eeb7831191ebfd0c4baaf2fa632004b296d9fb58894982b2a49efe97c14a47e4"
    sha256 cellar: :any, catalina:      "2c65823033f2e44c172d9bf9734101087f1ebdd2f279509fda25161eb791e7b0"
    sha256 cellar: :any, mojave:        "a5c3fbb5507a9f2bb65bff960f1a0f1c0e49fa98b11da5cd2104b92ef698d2e9"
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
