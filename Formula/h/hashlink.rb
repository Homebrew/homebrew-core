class Hashlink < Formula
  desc "Virtual machine for Haxe"
  homepage "https://hashlink.haxe.org/"
  url "https://github.com/HaxeFoundation/hashlink/archive/refs/tags/1.14.tar.gz"
  sha256 "7def473c8fa620011c7359dc36524246c83d0b6a25d495d421750ecb7182cc99"
  license "MIT"
  head "https://github.com/HaxeFoundation/hashlink.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 sonoma:       "9bc18cb2e8a82cb99b34a7eaf19eeb8ff4405c3d79483fa23d9ec88b72bff2e3"
    sha256 cellar: :any,                 ventura:      "be5138e19ca169d89599973b99cab4cd328c3a6705e31eb9c297d8a3198ef275"
    sha256 cellar: :any,                 monterey:     "60a333d41591f12ff610ccb1940280c76a4878455ee0a826dedd0e480f956cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "71c452f956c884f225622ebd0374eca54105c21284e704e024b6b86afb673dfa"
  end

  depends_on "haxe" => :test
  depends_on "jpeg-turbo"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libuv"
  depends_on "libvorbis"
  depends_on "mbedtls@2"
  depends_on "openal-soft"
  depends_on "sdl2"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    if OS.mac?
      # make file doesn't set rpath on mac yet
      system "make", "PREFIX=#{libexec}", "EXTRA_LFLAGS=-Wl,-rpath,#{libexec}/lib"
    else
      # On Linux, also set RPATH in LIBFLAGS, so that the linker will also add the RPATH to .hdll files.
      inreplace "Makefile", "LIBFLAGS =", "LIBFLAGS = -Wl,-rpath,${INSTALL_LIB_DIR}"
      system "make", "PREFIX=#{libexec}"
    end

    system "make", "install", "PREFIX=#{libexec}"
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    haxebin = Formula["haxe"].bin

    (testpath/"HelloWorld.hx").write <<~EOS
      class HelloWorld {
          static function main() Sys.println("Hello world!");
      }
    EOS
    system "#{haxebin}/haxe", "-hl", "HelloWorld.hl", "-main", "HelloWorld"
    assert_equal "Hello world!\n", shell_output("#{bin}/hl HelloWorld.hl")

    (testpath/"TestHttps.hx").write <<~EOS
      class TestHttps {
        static function main() {
          var http = new haxe.Http("https://www.google.com/");
          http.onStatus = status -> Sys.println(status);
          http.onError = error -> {
            trace('error: $error');
            Sys.exit(1);
          }
          http.request();
        }
      }
    EOS
    system "#{haxebin}/haxe", "-hl", "TestHttps.hl", "-main", "TestHttps"
    assert_equal "200\n", shell_output("#{bin}/hl TestHttps.hl")

    (testpath/"build").mkdir
    system "#{haxebin}/haxelib", "newrepo"
    system "#{haxebin}/haxelib", "install", "hashlink"

    system "#{haxebin}/haxe", "-hl", "HelloWorld/main.c", "-main", "HelloWorld"

    flags = %W[
      -I#{libexec}/include
      -L#{libexec}/lib
    ]
    flags << "-Wl,-rpath,#{libexec}/lib" unless OS.mac?

    system ENV.cc, "HelloWorld/main.c", "-O3", "-std=c11", "-IHelloWorld",
                   *flags, "-lhl", "-o", "build/HelloWorld"
    assert_equal "Hello world!\n", `./build/HelloWorld`

    system "#{haxebin}/haxe", "-hl", "TestHttps/main.c", "-main", "TestHttps"
    system ENV.cc, "TestHttps/main.c", "-O3", "-std=c11", "-ITestHttps",
                   *flags, "-lhl", "-o", "build/TestHttps", libexec/"lib/ssl.hdll"
    assert_equal "200\n", `./build/TestHttps`
  end
end
