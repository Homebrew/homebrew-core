class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.5.1.tar.gz"
  sha256 "cfd75dc9eb1a0e1598f59c2632b9932069eb27793f38786452fbac9e520653dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4c1e5628b7ae614142f3631cc44d14351fe732de273d1d60813dacd547706ffa"
    sha256 cellar: :any, big_sur:       "ab5ac2c9eff849840ef83533faedf536ae1ef9cf97b9291198eca6ccf96a1218"
    sha256 cellar: :any, catalina:      "b3bd679f9b35ab1018b4c7284442ebf9e03f3bcec6b108268a44ccacbce5a874"
    sha256 cellar: :any, mojave:        "8b48e82365ad52abb59af1b5c75e28cbac0b782b9dca0c4ac145bcfdf8a8b6d1"
  end

  depends_on "autoconf" => :build
  depends_on "gmp" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
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
