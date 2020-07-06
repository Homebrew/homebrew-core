class Hashlink < Formula
  desc "Virtual machine for Haxe"
  homepage "https://hashlink.haxe.org/"
  url "https://github.com/HaxeFoundation/hashlink/archive/1.11.tar.gz"
  sha256 "b087ded7b93c7077f5b093b999f279a37aa1e31df829d882fa965389b5ad1aea"
  license "MIT"
  head "https://github.com/HaxeFoundation/hashlink.git"

  bottle do
    sha256 "d8911ee23e791b7cf2cc1b1ef443182d85133d4161bab29ab2da69bcfd1aed66" => :catalina
    sha256 "16162d83b4b6962b9422b8b78a8f85f186254c9dcc1640a461b9f7b9b2a38fed" => :mojave
    sha256 "04539eb5366f0c48928b5e625a3b403746749d73fc4b97ef58806bb0e994c95b" => :high_sierra
  end

  depends_on "haxe" => :test
  depends_on "jpeg-turbo"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libuv"
  depends_on "libvorbis"
  depends_on "mbedtls"
  depends_on "openal-soft"
  depends_on "sdl2"

  def install
    inreplace "Makefile", /\$\{LFLAGS\}/, "${LFLAGS} ${EXTRA_LFLAGS}" unless build.head?
    system "make", "EXTRA_LFLAGS=-Wl,-rpath,#{libexec}/lib"
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
    system ENV.cc, "-O3", "-std=c11", "-IHelloWorld", "-I#{libexec}/include", "-L#{libexec}/lib", "-lhl",
                   "HelloWorld/main.c", "-o", "build/HelloWorld"
    assert_equal "Hello world!\n", `./build/HelloWorld`

    system "#{haxebin}/haxe", "-hl", "TestHttps/main.c", "-main", "TestHttps"
    system ENV.cc, "-O3", "-std=c11", "-ITestHttps", "-I#{libexec}/include", "-L#{libexec}/lib", "-lhl",
                   "TestHttps/main.c", "-o", "build/TestHttps", libexec/"lib/ssl.hdll"
    assert_equal "200\n", `./build/TestHttps`
  end
end
