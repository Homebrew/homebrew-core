class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      :tag      => "4.1.3",
      :revision => "c7d2c7aac5f8d280d694e46fc1c9de52e218b9c6"
  head "https://github.com/HaxeFoundation/haxe.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "58e9b7b73f79c5bed1ef707e98f89f84eec270e07dc04a78afed2e93c4a5167f" => :catalina
    sha256 "803f81f5a31bacd362eddc17965afed4fc2602ed6675684664cffe1106ff525b" => :mojave
    sha256 "f059682fe20e23e924a870366dd3a5aed85ff33ed3b000d104fb099e0b088a68" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"
  depends_on "neko"
  depends_on "pcre"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize

    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["ADD_REVISION"] = "1" if build.head?
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "config", "exec", "--",
             "opam", "pin", "add", "haxe", buildpath, "--no-action"
      system "opam", "config", "exec", "--",
             "opam", "install", "haxe", "--deps-only"
      system "opam", "config", "exec", "--",
             "make"
    end

    # Rebuild haxelib as a valid binary
    cd "extra/haxelib_src" do
      system "cmake", ".", *std_cmake_args
      system "make"
    end
    rm "haxelib"
    cp "extra/haxelib_src/haxelib", "haxelib"

    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}",
           "INSTALL_LIB_DIR=#{lib}/haxe", "INSTALL_STD_DIR=#{lib}/haxe/std"
  end

  def caveats
    <<~EOS
      Add the following line to your .bashrc or equivalent:
        export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end

  test do
    ENV["HAXE_STD_PATH"] = "#{HOMEBREW_PREFIX}/lib/haxe/std"
    system "#{bin}/haxe", "-v", "Std"
    system "#{bin}/haxelib", "version"

    (testpath/"HelloWorld.hx").write <<~EOS
      import js.html.Console;

      class HelloWorld {
          static function main() Console.log("Hello world!");
      }
    EOS
    system "#{bin}/haxe", "-js", "out.js", "-main", "HelloWorld"
    _, stderr, = Open3.capture3("osascript -so -lJavaScript out.js")
    assert_match /^Hello world!$/, stderr
  end
end
