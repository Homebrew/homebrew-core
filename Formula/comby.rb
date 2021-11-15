class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.7.0.tar.gz"
  sha256 "fd1351d534c905774ceb4b1e908d81e67eeff007c8b9c4a28fe145e85c7c5f5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "b485975d5d68e312bd3484b39e4d773952e484bdf67e7b73ce97adbd006c921a"
    sha256 cellar: :any, arm64_big_sur:  "e69e426df9a510b7cad1d678a8f52f6f81a695d0c93cac191eee88e80d83e6a0"
    sha256 cellar: :any, monterey:       "cc0567df34dba07308d4101d3813eba1d8fa7613aaf04b720fd8567a4665abf6"
    sha256 cellar: :any, big_sur:        "80f3ea766ee4112f5ce4078ad71d6baea73d21399e1fd1ba333284c39ebe5db6"
    sha256 cellar: :any, catalina:       "5cb7e5544575697571c82f1f6d480f93e1c9cbc8ca74006f6cb147ccb3a1b48c"
    sha256 cellar: :any, mojave:         "aecfaad20f49d0ad545a4f4cb7ebd6056371f40804490c9ae38804669e9a73d7"
    sha256               x86_64_linux:   "d61e66ffead20155383921643c2e4c95ad49c2e845b0e5476250052ab1530763"
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
