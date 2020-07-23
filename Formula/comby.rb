class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/0.17.0.tar.gz"
  sha256 "5f45a49b1d2e412e2774333df43a4955e585098b748db484a520e98b57385c91"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "0f53fe71e3908a0d12571e20bfb3f9ed969a17d823e95281513312a3024e74e1" => :catalina
    sha256 "7d08b2c3033529ca796125e666063df36e2eb036448ffb0a60b3bd141cc7f9d3" => :mojave
    sha256 "d41bc25a97d82c1a8ef3a8f73014c4911edcfe153e11fb0b7a37b8d729b83c37" => :high_sierra
  end

  depends_on "gmp" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pcre"
  depends_on "pkg-config"

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
