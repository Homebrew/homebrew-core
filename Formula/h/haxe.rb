class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  # TODO: Remove `ctypes==0.22.0` pin when `luv >= 0.5.14` for https://github.com/aantron/luv/issues/159
  url "https://github.com/HaxeFoundation/haxe.git",
      tag:      "4.3.7",
      revision: "e0b355c6be312c1b17382603f018cf52522ec651"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  revision 3
  head "https://github.com/HaxeFoundation/haxe.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e3e44a1008fad87b7dacd36c12af42b2e47effdf570f41f5545a1fc5b98cf692"
    sha256 cellar: :any, arm64_sequoia: "ead9a4b59aa64ed4672abe196cb614f42631bdee3e17db26123b6585220cfd97"
    sha256 cellar: :any, arm64_sonoma:  "30cf377cb3bdd57d83dceda64f11706e310c5ef9305f4a9e43fde00a9d52be59"
    sha256 cellar: :any, sonoma:        "b8aae356d6eddbbc15e8f503c1ad09cf535ac8b83d599f9f9735cb3a60e7d9a5"
    sha256               arm64_linux:   "0db5ab6a769a2ce06028522bc826b5e76d76b07768d400203cac487e6c635556"
    sha256               x86_64_linux:  "eee285b19a15c09532b6eec072ac2d501e7c6ccdea0e1df8e3ecf3e1758769ec"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "mbedtls@3"
  depends_on "neko"
  depends_on "pcre2"

  on_linux do
    depends_on "node" => :test
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround for OCaml >= 5.4 until next release. This only drops upper bound added for Windows.
    # https://github.com/HaxeFoundation/haxe/commit/034178b97ba0d7a97e0230ecf76b5872c4b3c197
    inreplace "haxe.opam", '"dune" {>= "1.11" & < "3.16"}', '"dune" {>= "1.11"}' if build.stable?

    ENV["OPAMROOT"] = opamroot = buildpath/".opam"
    ENV["OPAMYES"] = "1"
    ENV["ADD_REVISION"] = "1" if build.head?

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "pin", "add", "ctypes", "0.22.0"

    # OCaml 5.5.0 no longer exposes opam's C stubs (e.g. dllpcre2_stubs.so) for linking.
    # https://github.com/ocaml/opam-repository/issues/16406
    ENV.prepend_path "CAML_LD_LIBRARY_PATH", opamroot/"ocaml-system/lib/stublibs"

    system "opam", "install", ".", "--deps-only", "--no-depexts"

    # Build requires targets to be built in specific order
    ENV.deparallelize { system "opam", "exec", "--", "make" }

    system "make", "install", "INSTALL_BIN_DIR=#{bin}",
                              "INSTALL_LIB_DIR=#{lib}/haxe",
                              "INSTALL_STD_DIR=#{lib}/haxe/std"
  end

  def caveats
    <<~EOS
      Add the following line to your .bashrc or equivalent:
        export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end

  test do
    ENV["HAXE_STD_PATH"] = HOMEBREW_PREFIX/"lib/haxe/std"

    system bin/"haxe", "-v", "Std"
    system bin/"haxelib", "version"

    (testpath/"HelloWorld.hx").write <<~HAXE
      import js.html.Console;

      class HelloWorld {
          static function main() Console.log("Hello world!");
      }
    HAXE
    system bin/"haxe", "-js", "out.js", "-main", "HelloWorld"

    cmd = if OS.mac?
      "osascript -so -lJavaScript out.js 2>&1"
    else
      "node out.js"
    end
    assert_equal "Hello world!", shell_output(cmd).strip
  end
end
