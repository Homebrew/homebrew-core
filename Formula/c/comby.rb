class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/refs/tags/1.8.1.tar.gz"
  sha256 "04d51cf742bbbf5e5fda064a710be44537fac49bff598d0e9762a3a799d666e2"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "02e4b812a3a7196017189b30aba83d058f72fbe37107c554c517538eeb153fee"
    sha256 cellar: :any, arm64_sonoma:   "6547d31a4235741700836ce54b0fdf64bbc0ca2ac42e31ce003c1d86bef079f0"
    sha256 cellar: :any, arm64_ventura:  "0c2cc4ae48e83842879b731399da84e9eb6891bf2c62a10087250db18c257a38"
    sha256 cellar: :any, arm64_monterey: "c5e30b40a5bfca4e550da1ff541deeb4a467eef42298de85c72110e373b68c11"
    sha256 cellar: :any, sonoma:         "1d1399b5fb4f1c0c1fc167a8a758392a8e7fd261ee351f40460079d110dbc27b"
    sha256 cellar: :any, ventura:        "615cb295eabe9a99891de27aff6950ce729664949a92c705b5e5ce1d61f20687"
    sha256 cellar: :any, monterey:       "660da52140d4812766f9f942966068c6076d8122b41dfc2a2a2c21e0de2066cb"
    sha256               arm64_linux:    "09a23c45c18a469df962efd914eb19de9b967f1dd63dd21f9124733f31434e54"
    sha256               x86_64_linux:   "6a87649180d98f7555771ceb9d6062a1ce98f2aaaff996f52f9f8249bf300a8c"
  end

  depends_on "autoconf" => :build
  depends_on "gmp" => :build
  depends_on "ocaml@4" => :build # https://github.com/comby-tools/comby/issues/358
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
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
    # Workaround for https://github.com/comby-tools/comby/issues/381
    system "opam", "exec", "--", "opam", "pin", "add", "tar-unix", "2.6.0"
    system "opam", "exec", "--", "opam", "install", ".", "--deps-only", "-y", "--no-depexts"

    ENV.prepend_path "LIBRARY_PATH", opamroot/"default/lib/hack_parallel" # for -lhp
    system "opam", "exec", "--", "make", "release"

    bin.install "_build/default/src/main.exe" => "comby"
  end

  test do
    expect = <<~DIFF
      --- test.c
      +++ test.c
      @@ -1,3 +1,3 @@
       int main(void) {
      -  printf("hello world!");
      +  printf("comby, hello!");
       }
    DIFF

    (testpath/"test.c").write <<~C
      int main(void) {
        printf("hello world!");
      }
    C

    match = 'printf(":[1] :[2]!")'
    rewrite = 'printf("comby, :[1]!")'

    assert_equal expect, shell_output("#{bin}/comby '#{match}' '#{rewrite}' test.c -diff")
  end
end
