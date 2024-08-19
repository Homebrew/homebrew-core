class Hashlink < Formula
  desc "Virtual machine for Haxe"
  homepage "https://hashlink.haxe.org/"
  license "MIT"
  head "https://github.com/HaxeFoundation/hashlink.git", branch: "master"

  stable do
    url "https://github.com/HaxeFoundation/hashlink/archive/refs/tags/1.14.tar.gz"
    sha256 "7def473c8fa620011c7359dc36524246c83d0b6a25d495d421750ecb7182cc99"

    # Backport support for mbedtls 3.x
    patch do
      url "https://github.com/HaxeFoundation/hashlink/commit/5406694b010f30a244d28626c8fd93fc335adcec.patch?full_index=1"
      sha256 "4bf2739b2e1177e6ad325829dcd5e4e2b600051549773efbb1b01a53349365a6"
    end
    patch do
      url "https://github.com/HaxeFoundation/hashlink/commit/54e97e34f29e80bcdccdb69af8ccd02bd7c0bc3a.patch?full_index=1"
      sha256 "d5c1cd0a1aed504b01eee275459cc54d219092265f71f505a5491cced6e0061b"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 sonoma:       "634e38f8a64155e16ddb999eab19427709d6fe291196bedf29031a1b968323d9"
    sha256 cellar: :any,                 ventura:      "77e7de64a612b4361d83d1aa7a1330922b79af11e6d601effc93a80c09f41a2a"
    sha256 cellar: :any,                 monterey:     "d1c623f5da8cdd74858a29225dd640ea49e004bc3fbf1e079ad79ad9dec87100"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2b9d5a710e10e612ba4ac82c74bec61354d9606912735e7f6a706298a68fcf75"
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

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

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
