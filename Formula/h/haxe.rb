class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  # TODO: Remove `ctypes==0.22.0` pin when `luv >= 0.5.14` for https://github.com/aantron/luv/issues/159
  url "https://github.com/HaxeFoundation/haxe.git",
      tag:      "4.3.7",
      revision: "e0b355c6be312c1b17382603f018cf52522ec651"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  revision 2
  head "https://github.com/HaxeFoundation/haxe.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c4f56c37d8b1f2508636ab8d35d53ded1377ac689e2661d047da81513df63cd8"
    sha256 cellar: :any, arm64_sequoia: "a35d7d94ebaefc02520f426635808c894685a501cc62f45623f9c19d580a4d3d"
    sha256 cellar: :any, arm64_sonoma:  "8a968b4ceb5172135d8e308eaa422afd3d3f0b883a30fe92e016f47cc3792781"
    sha256 cellar: :any, sonoma:        "a2c7966de13c1763ac18df3094062346b7e2c683311f997d6b6f7ca5156fcb5e"
    sha256               arm64_linux:   "e30e40f489afe3ae9ae3472a2061123e82833cf045001602481e5a8c148f6886"
    sha256               x86_64_linux:  "5d17640c42c56a2dde34932163f643b0f574152bc97b9f36b074308d99bbae3d"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "mbedtls@3"
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
