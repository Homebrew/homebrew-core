class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.7.1.tar.gz"
  sha256 "47df841b470643dafd9ced7938dfdfb8623dea91bb7b4ec34a1d80fe6e3af1f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1e2fe680593066dba33d0f22cae0caa875351bfceff18a89680fdd5263c3c468"
    sha256 cellar: :any, arm64_big_sur:  "cfc83f2a14afc4bef1248950012f1c55ba801104692c9b11eafbfa5f0036d4cf"
    sha256 cellar: :any, monterey:       "583adfe2ccad7f99f35edf12dfdcd28ae4fee01aa6baac6868cf905501948abe"
    sha256 cellar: :any, big_sur:        "72ba0ae22b0274bd700f55ddc361f9a458283e5073fa590342b3ce827d6ff549"
    sha256 cellar: :any, catalina:       "f1c261c4507c922a7e4c493ec7fc37e913b764d2b14f694fa36523a681ee9a32"
    sha256               x86_64_linux:   "afc598e4207fa34a87d2cb5a48afdd9da6ff464a057cb3198b0ace3af9ac7acc"
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
    system "opam", "exec", "--", "opam", "install", ".", "--deps-only", "-y", "--no-depexts"

    ENV.prepend_path "LIBRARY_PATH", opamroot/"default/lib/hack_parallel" # for -lhp
    system "opam", "exec", "--", "make", "release"

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
