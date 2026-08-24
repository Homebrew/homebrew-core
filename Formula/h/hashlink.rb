class Hashlink < Formula
  desc "Virtual machine for Haxe"
  homepage "https://hashlink.haxe.org/"
  url "https://github.com/HaxeFoundation/hashlink/archive/refs/tags/1.16.tar.gz"
  sha256 "c392ce6e1d3670bcb60c85d83a161591707de9cdb6b00b48e79f9ea7807fc5a9"
  license "MIT"
  head "https://github.com/HaxeFoundation/hashlink.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a7f1b7bd2d084befd08ccc1a7b5f05fb982497e37c2b58f0ab4375a114f36fe8"
    sha256 cellar: :any, arm64_sequoia: "eda46e0a3237e12be3e314a0740236802febe02b5ea0211f2d04c1b570473f5e"
    sha256 cellar: :any, arm64_sonoma:  "bb29479f1a69924cbeeef56223aba8308f62a1777c7daa1161fe4c147c86badb"
    sha256 cellar: :any, sonoma:        "dd0624dab469e02d214f598339b9881c9ad0dad59a11140d7bb9210f33363f35"
    sha256 cellar: :any, arm64_linux:   "e8af66f5bf10c4186694e2d12f059d4f4e946313953705022896e679bf2bf2e3"
    sha256 cellar: :any, x86_64_linux:  "d4983f2cbe53b940c32c193ed345d1f07d226746a0f43db3ea4cd719769d7763"
  end

  depends_on "pkgconf" => :build
  depends_on "haxe" => :test
  depends_on "jpeg-turbo"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libuv"
  depends_on "libvorbis"
  depends_on "mbedtls@3"
  depends_on "openal-soft"
  depends_on "sdl3"

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
    args << "ARCH=arm64" if OS.linux? && Hardware::CPU.arm?

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

    (testpath/"HelloWorld.hx").write <<~HAXE
      class HelloWorld {
          static function main() Sys.println("Hello world!");
      }
    HAXE

    (testpath/"TestHttps.hx").write <<~HAXE
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
    HAXE

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
