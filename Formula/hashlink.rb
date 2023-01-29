class Hashlink < Formula
  desc "Virtual machine for Haxe"
  homepage "https://hashlink.haxe.org/"
  url "https://github.com/HaxeFoundation/hashlink/archive/1.13.tar.gz"
  sha256 "696aef6871771e5e12c617df79187d1761e79bcfe3927531e99f665a8002956f"
  license "MIT"
  head "https://github.com/HaxeFoundation/hashlink.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 ventura:      "aebc07d5b327f360bf8a98075f372ddddfa5d82c5e3c8c73b4448b36daf95476"
    sha256 cellar: :any,                 monterey:     "6ceecb580787e3968b24652cc90198895524bf6208a49f36a2a59df2b7fedaff"
    sha256 cellar: :any,                 big_sur:      "0de282297d22fabbcaa317504bb44318e5530c70490d23cb36300c374a1bfbd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1622942df58df95150ebcb84d1535e3b98b9934ac13dada76f45b63befb8de16"
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
