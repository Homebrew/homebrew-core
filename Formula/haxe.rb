class Haxe < Formula
  desc "Multi-platform programming language"
  homepage "https://haxe.org/"
  url "https://github.com/HaxeFoundation/haxe.git",
      :tag      => "4.1.1",
      :revision => "5e3f33b5c1c66d22607b264f7cd3107881788765"
  head "https://github.com/HaxeFoundation/haxe.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "ef1bb238d8c8089ee421bdd9fa4616a9ed0807ad05445aadabbb083475a59518" => :catalina
    sha256 "7f025c2108351099a5c07022e1d90afd8abd66561900ee60b54192f786690c1b" => :mojave
    sha256 "0542535c45d04443c03982ab51b7fc1b5394592ab1f66b5b92b42e47ba30f797" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"
  depends_on "neko"
  depends_on "pcre"

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
