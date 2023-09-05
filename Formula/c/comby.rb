class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/1.8.1.tar.gz"
  sha256 "04d51cf742bbbf5e5fda064a710be44537fac49bff598d0e9762a3a799d666e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "ead924a94b73aede202b3afc9146124efb1ac7b8416e0b0119a59cf2ab6d3310"
    sha256 cellar: :any, arm64_monterey: "c75ee2deab2abc20778e51a40cbb7ca305948dc0e10c6e13e9d23004d26f8dfb"
    sha256 cellar: :any, arm64_big_sur:  "886f0b5d1a6ac7075a18f3d0075578e81ae2462656a578cf61c344622629a5a4"
    sha256 cellar: :any, ventura:        "535c3320832e70d126405a7535298c615dfdaa66e0ee0ddceaae680d3f189113"
    sha256 cellar: :any, monterey:       "8e84488e24e0df5a5bbee5a2df201eb1027c90d177ebcd8bf030c91dec47d636"
    sha256 cellar: :any, big_sur:        "72ce5e95f8772bc54d8d8706ed06e08ab99b9a6eb2682d8fea480ed1be202704"
    sha256 cellar: :any, catalina:       "7519ef48876a5d5b3636556b0b6987c1c9ec7b568d299c49b849036aafcb61bb"
    sha256               x86_64_linux:   "275be90d9ac8149c51abc9c5fc972e7aff125326cdadfd1ed0f55a8d6d84dc15"
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
