class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/refs/tags/1.8.1.tar.gz"
  sha256 "04d51cf742bbbf5e5fda064a710be44537fac49bff598d0e9762a3a799d666e2"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "a14c34f746c83276aab070a8b4c374fb67e3a2226a889dfaa2074f4fa25dfa7c"
    sha256 cellar: :any, arm64_sequoia: "e9e977b807fdf51032eb7f7c28abad907dca2669ec81533e76b00ce0534eb740"
    sha256 cellar: :any, arm64_sonoma:  "6eb60059840e52ae180b9047f35ec501c7a1018a129561470841c7a5d688cecf"
    sha256 cellar: :any, sonoma:        "b0f4a77f35f43d41ae307751856fa7c45adfef51610814a502178d5f59b2a294"
    sha256               arm64_linux:   "a8d1c6ed89c97eb202e20f69ac97e7ff2d66f219779af199cf2a84f1773e3587"
    sha256               x86_64_linux:  "9712877884110dfdc5b25e2bd9ac75960ebecafb5191669894680123bd767664"
  end

  # https://github.com/comby-tools/comby/issues/358
  # https://github.com/comby-tools/comby/issues/381
  # https://github.com/comby-tools/comby/issues/392
  deprecate! date: "2026-01-13", because: "needs EOL `pcre`, OCaml < 5 and multiple workarounds to build"
  disable! date: "2027-01-13", because: "needs EOL `pcre`, OCaml < 5 and multiple workarounds to build"

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

  # Workaround for error due to `-mpopcnt` on arm64 macOS with Xcode 16.3+.
  # TODO: Remove once base >= 0.17.3 or if fix is backported to 0.14 and released
  on_sequoia :or_newer do
    on_arm do
      resource "base" do
        url "https://github.com/janestreet/base/archive/refs/tags/v0.14.3.tar.gz"
        sha256 "e34dc0dd052a386c84f5f67e71a90720dff76e0edd01f431604404bee86ebe5a"
      end

      # Getting fixed file from 0.17.3 as commit doesn't cleanly apply
      # https://github.com/janestreet/base/commit/68f18ed6a5e94dda1ed423c3435d1515259dcc7d
      resource "discover.ml" do
        url "https://raw.githubusercontent.com/janestreet/base/refs/tags/v0.17.3/src/discover/discover.ml"
        sha256 "07654aaab7e891ccae019d008155aaf2a48cfd64b5dc402c0779554d6e59967a"
      end
    end
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize
    opamroot = buildpath/".opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    # Workaround for https://github.com/comby-tools/comby/issues/381
    system "opam", "pin", "add", "tar-unix", "2.6.0"
    # Workaround for https://github.com/janestreet/base/issues/164
    if OS.mac? && MacOS.version >= :sequoia
      resource("base").stage do
        resource("discover.ml").stage("src/discover")
        system "opam", "install", ".", "--yes", "--no-depexts", "--working-dir"
      end
    end
    system "opam", "install", ".", "--deps-only", "--yes", "--no-depexts"

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
