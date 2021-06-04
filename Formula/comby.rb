class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.6.0.tar.gz"
  sha256 "bd288ff606f972f9bf2bfb14d967731ff5dd8358d4f2bba7ab4cdc65273cd7bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "452877f9b07c40d246f24bea38f318c064c3ef0492513baaabe129e58d8513e4"
    sha256 cellar: :any, big_sur:       "fb56717bfc4f4eade203b400a0b89895ce868259e5de9d64a6b8647fec824bff"
    sha256 cellar: :any, catalina:      "c502d02ba6108b3ff17304e0485eb10b75ecba479e528128633465332f2bff89"
    sha256 cellar: :any, mojave:        "ac79a5af6da615860f53ee80b1898ecd0bc393d4072a57c0b1ecf56b789a61bf"
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
