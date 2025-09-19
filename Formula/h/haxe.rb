class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  # TODO: Remove `ctypes==0.22.0` pin when `luv >= 0.5.14` for https://github.com/aantron/luv/issues/159
  url "https://github.com/HaxeFoundation/haxe.git",
      tag:      "4.3.7",
      revision: "e0b355c6be312c1b17382603f018cf52522ec651"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  head "https://github.com/HaxeFoundation/haxe.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ff407c6fd1b72e4917998f5d9a6a1d4777776c4a67551f71bd6bbdb0670a244e"
    sha256 cellar: :any, arm64_sequoia: "e011aeeeb482b18de582dcad962953ec0edf9637acd491f959e15cea302c37d7"
    sha256 cellar: :any, arm64_sonoma:  "7796fc935342120125c6cb3277bc3141d36a144700a0ef03727c6d7c546d1d47"
    sha256 cellar: :any, arm64_ventura: "60777aeacf877a0f8c7efff38e8b0b15b9d97ea177b1be9ba2e040860b102f01"
    sha256 cellar: :any, sonoma:        "b4ba8d151a43195f811ed0b4e133d8aad49bd71be3ff9d768a2d5c418463b1a4"
    sha256 cellar: :any, ventura:       "bc1fa4ece804968ce1e07a7a2fc16d50344366c4136d4349d3e4b98b1f12aa90"
    sha256               arm64_linux:   "fc65cd159d91ae1e81477f40e0064f271b565bd8f838b68fe350bf69c612c7ab"
    sha256               x86_64_linux:  "48e54f10062256bb9f85612856043074d9ff91539635bee89cfb90b148052a2b"
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
