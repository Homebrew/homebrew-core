class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.1.0.tar.gz"
  sha256 "c843c44dd75160454f49c9fad3785e840762e73ada35bd40adf394cb5933a505"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, big_sur:  "6774e08b88b128ab63b9580e40b42f62d9eacd6fa46ecde4f6f83eaecdea82ef"
    sha256 cellar: :any, catalina: "817f96bf3ebb4a3fc27a266e3bf655da0d6e2910ccee81583bb6492af3eb8e30"
    sha256 cellar: :any, mojave:   "7ed775050f3e6178333a19e43d060f6a830c9ff89074233c77cd5cbd4c65971a"
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
