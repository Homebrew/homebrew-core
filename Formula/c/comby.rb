class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/refs/tags/1.8.1.tar.gz"
  sha256 "04d51cf742bbbf5e5fda064a710be44537fac49bff598d0e9762a3a799d666e2"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "9879569428b8a7bde2b56490bf6bd99cf5f0cdc1c524250af7173eae9b3b6621"
    sha256 cellar: :any, arm64_ventura:  "375dd89916c279b00020467fdbb699d05807a6caf866ad35fa76d9adabcaff8b"
    sha256 cellar: :any, arm64_monterey: "fb4cc78f0a4a95aa911d3bc4a619e53fae22a1bd5a4bbb94e17cdc849baa4485"
    sha256 cellar: :any, sonoma:         "fb116fe361c37cefad3d3d4aa0d37a8a76264e2920d3d9d49c4996423aaab5d4"
    sha256 cellar: :any, ventura:        "f46b53e793bbce9dd888ec53a90224566c2b52ce4c2db664f93a945a425ac52c"
    sha256 cellar: :any, monterey:       "54ab143ff66d46db4a02ad2c373edabf4c9ad23af83c0fd4945dc66b41ce9772"
    sha256               x86_64_linux:   "919a845aa0880568e9ca2288c6f390437a8e14a12a59a597e0b8e90f0f540b79"
  end

  depends_on "autoconf" => :build
  depends_on "gmp" => :build
  depends_on "ocaml@4" => :build # https://github.com/comby-tools/comby/issues/358
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
