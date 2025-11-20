class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  # TODO: Remove `ctypes==0.22.0` pin when `luv >= 0.5.14` for https://github.com/aantron/luv/issues/159
  url "https://github.com/HaxeFoundation/haxe.git",
      tag:      "4.3.7",
      revision: "e0b355c6be312c1b17382603f018cf52522ec651"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  revision 1
  head "https://github.com/HaxeFoundation/haxe.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "10f2be52a22ae138d51ff32f1149f961deb3b5db78841ee8ae8a8bea69891eb0"
    sha256 cellar: :any, arm64_sequoia: "2743448f3874a8ede755959b55aa380bc0a943b49acf917be7b9dad04b536f3c"
    sha256 cellar: :any, arm64_sonoma:  "6fcc4da27a9f97238ce553ac764df40cd5afcde364282ebcc253ad34ee9f0f33"
    sha256 cellar: :any, sonoma:        "042ee8b6afb033d6a7e79f02dbab3231f94908b135579553171906b4f954aacf"
    sha256               arm64_linux:   "25d45366d303ec6fbfec16fa250f39fff1ca07bd6fcedbef6776eaee82b5ce03"
    sha256               x86_64_linux:  "95536545ad4802b7f048dccdc900f3b0aba6fd750a14191fde04948f40516923"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "mbedtls"
  depends_on "neko"
  depends_on "pcre2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "node" => :test
  end

  def install
    # Workaround for OCaml >= 5.4 until next release. This only drops upper bound added for Windows.
    # https://github.com/HaxeFoundation/haxe/commit/034178b97ba0d7a97e0230ecf76b5872c4b3c197
    inreplace "haxe.opam", '"dune" {>= "1.11" & < "3.16"}', '"dune" {>= "1.11"}' if build.stable?

    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"
    ENV["ADD_REVISION"] = "1" if build.head?

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "pin", "add", "ctypes", "0.22.0"
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

    (testpath/"HelloWorld.hx").write <<~EOS
      import js.html.Console;

      class HelloWorld {
          static function main() Console.log("Hello world!");
      }
    EOS
    system bin/"haxe", "-js", "out.js", "-main", "HelloWorld"

    cmd = if OS.mac?
      "osascript -so -lJavaScript out.js 2>&1"
    else
      "node out.js"
    end
    assert_equal "Hello world!", shell_output(cmd).strip
  end
end
