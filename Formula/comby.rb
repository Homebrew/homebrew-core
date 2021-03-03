class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.2.1.tar.gz"
  sha256 "acb163da5b9112fc1095811f87a69147bf0bce387f412d8414568acf09b4d932"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e28d8399c565ecd4573c3ef7f084eba5ad6b21e0e2b6a48d9bfe9efae1789711"
    sha256 cellar: :any, big_sur:       "fbfdc837f78e60a04c98874ca7e8dc57b1fc5f8c2d2e3286ebf2eabdbe1a2009"
    sha256 cellar: :any, catalina:      "fe0b2f93578ba87289241d49448abce8a1eaaf174edea3ef763b25eae052b5f9"
    sha256 cellar: :any, mojave:        "5db851248522674a39ec430a571344b27fa14aec255ec6b5d29dae16b4fa71b2"
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
