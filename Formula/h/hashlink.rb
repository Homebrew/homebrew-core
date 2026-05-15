class Hashlink < Formula
  desc "Virtual machine for Haxe"
  homepage "https://hashlink.haxe.org/"
  license "MIT"
  revision 1
  head "https://github.com/HaxeFoundation/hashlink.git", branch: "master"

  stable do
    url "https://github.com/HaxeFoundation/hashlink/archive/refs/tags/1.15.tar.gz"
    sha256 "3c3e3d47ed05139163310cbe49200de8fb220cd343a979cd1f39afd91e176973"

    # Backport fix for arm64 linux, https://github.com/HaxeFoundation/hashlink/pull/765
    patch do
      url "https://github.com/HaxeFoundation/hashlink/commit/6794cdbe4407d26f405e5978890de67d4d42a96d.patch?full_index=1"
      sha256 "fe885f32e89831a3269cb0da738316843af8ee80f55dc859c97a9cfb1725e7d8"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "63eb38d4dbc69ab9f8c71ecfd3c8b1f81673ddf015454e0141289747c0ac4269"
    sha256 cellar: :any,                 arm64_sequoia: "f81bd39b0a2962b274cad50e95190e5c86d4f9da5cbd27b8b5a7a3c807e3af00"
    sha256 cellar: :any,                 arm64_sonoma:  "454fec90a208dd51f0a65bb848be96e8f343c2c1b038c7f26a7805cae6c74dbb"
    sha256 cellar: :any,                 sonoma:        "8e5ebb95cd5752506bef4698f51e476d7de12aa64ed962a0664a48ffc63d60d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48372fc177336412549a92467756268d1da1ca27718ef3b68b2b4824bee10a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d7d71f666e42bc1e991d8376470e7755653ec6b1629b4d080e2a5d3bb541b4d"
  end

  depends_on "haxe" => :test
  depends_on "jpeg-turbo"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libuv"
  depends_on "libvorbis"
  depends_on "mbedtls@3"
  depends_on "openal-soft"
  depends_on "sdl2"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  def install
    # NOTE: This installs lib/*.hdll files which would be audited by `--new`.
    # These appear to be renamed shared libraries specifically used by HashLink.
    args = ["PREFIX=#{prefix}"]

    if OS.linux?
      args << "ARCH=arm64" if Hardware::CPU.arm?
      # On Linux, also set RPATH in LIBFLAGS, so that the linker will also add the RPATH to .hdll files.
      inreplace "Makefile", "LIBFLAGS =", "LIBFLAGS = -Wl,-rpath,${INSTALL_LIB_DIR}"
    end

    system "make", *args
    system "make", "install", *args
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
