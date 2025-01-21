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
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "c4e82df868e4b04a3f1eabeb3166c81282cc6de61b4d22e469096fe6fb36e955"
    sha256 cellar: :any,                 arm64_sonoma:   "49c5e4244cc628ab69ce7dad3d7908dff8d61035d9f6c2f8298574ef35341a4e"
    sha256 cellar: :any,                 arm64_ventura:  "fd29a416c322068567b89dce7ea79f2d8977bbf87fadb3546fd2bcd253b36ba4"
    sha256 cellar: :any,                 arm64_monterey: "17054886a8d100e481b845a4a977a0aa5e5a354a4145f5911aeb837e14fae5b4"
    sha256 cellar: :any,                 sonoma:         "f30c155da0e4809aaaf95f42f70e975a669ab1cca3acbcb2da9adc0c7144cbf5"
    sha256 cellar: :any,                 ventura:        "b5d824577be90d958356a8b91ad3caee21db129bd0595cfa2d9d792fe583bba8"
    sha256 cellar: :any,                 monterey:       "9053a0d1ff26dc49ded63dac843e01ab4f5e3df43cadb99631e1596289d5ccfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "286beb90726c27f47fc2f27280ac1b682ccfde139bf669d628958a9b6df85746"
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
    # NOTE: This installs lib/*.hdll files which would be audited by `--new`.
    # These appear to be renamed shared libraries specifically used by HashLink.
    args = ["PREFIX=#{prefix}"]

    if OS.mac?
      # make file doesn't set rpath on mac yet
      args << "EXTRA_LFLAGS=-Wl,-rpath,#{rpath}"
    else
      # On Linux, also set RPATH in LIBFLAGS, so that the linker will also add the RPATH to .hdll files.
      inreplace "Makefile", "LIBFLAGS =", "LIBFLAGS = -Wl,-rpath,${INSTALL_LIB_DIR}"
    end

    system "make", *args
    system "make", "install", *args
    return if Hardware::CPU.intel?

    # JIT only supports x86 and x86-64 processors
    rm(bin/"hl")
  end

  def caveats
    on_arm do
      <<~EOS
        The HashLink/JIT virtual machine (hl) is not installed as only
        HashLink/C native compilation is supported on ARM processors.

        See https://github.com/HaxeFoundation/hashlink/issues/557
      EOS
    end
  end

  test do
    haxebin = Formula["haxe"].bin

    (testpath/"HelloWorld.hx").write <<~EOS
      class HelloWorld {
          static function main() Sys.println("Hello world!");
      }
    EOS

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

    system "#{haxebin}/haxe", "-hl", "HelloWorld.hl", "-main", "HelloWorld"
    system "#{haxebin}/haxe", "-hl", "TestHttps.hl", "-main", "TestHttps"

    if Hardware::CPU.intel?
      assert_equal "Hello world!\n", shell_output("#{bin}/hl HelloWorld.hl")
      assert_equal "200\n", shell_output("#{bin}/hl TestHttps.hl")
    end

    (testpath/"build").mkdir
    system "#{haxebin}/haxelib", "newrepo"
    system "#{haxebin}/haxelib", "install", "hashlink"

    system "#{haxebin}/haxe", "-hl", "HelloWorld/main.c", "-main", "HelloWorld"

    flags = %W[
      -I#{include}
      -L#{lib}
    ]
    flags << "-Wl,-rpath,#{lib}" unless OS.mac?

    system ENV.cc, "HelloWorld/main.c", "-O3", "-std=c11", "-IHelloWorld",
                   *flags, "-lhl", "-o", "build/HelloWorld"
    assert_equal "Hello world!\n", `./build/HelloWorld`

    system "#{haxebin}/haxe", "-hl", "TestHttps/main.c", "-main", "TestHttps"
    system ENV.cc, "TestHttps/main.c", "-O3", "-std=c11", "-ITestHttps",
                   *flags, "-lhl", "-o", "build/TestHttps", lib/"ssl.hdll"
    assert_equal "200\n", `./build/TestHttps`
  end
end
