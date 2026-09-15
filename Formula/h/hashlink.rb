class Hashlink < Formula
  desc "Virtual machine for Haxe"
  homepage "https://hashlink.haxe.org/"
  url "https://github.com/HaxeFoundation/hashlink/archive/refs/tags/1.16.tar.gz"
  sha256 "c392ce6e1d3670bcb60c85d83a161591707de9cdb6b00b48e79f9ea7807fc5a9"
  license "MIT"
  head "https://github.com/HaxeFoundation/hashlink.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ccb57d0a18737a1a13d72719b6d458d1cac451030d3e9038a098a89907c7a6d2"
    sha256 cellar: :any, arm64_tahoe:       "1fea142f31dba20b19f08a1356ad960560071acfde00211a5f14105087c354ec"
    sha256 cellar: :any, arm64_sequoia:     "6992c2e2183662a7fba3df186a2c996d21561cd45cb418d4a23b1135bd526240"
    sha256 cellar: :any, arm64_linux:       "2e2c30a5a813cace3208c460d4f76715f73806c7094319ca8d1ea9765c5f5ec9"
    sha256 cellar: :any, x86_64_linux:      "62190ca7bad1f1feb11e38b998dc5f35901fc96dcb6143205547aac7c5cf491b"
  end

  deprecate! date: "2027-03-31", because: "needs deprecated `haxe` which needs EOL `mbedtls@3`"

  depends_on "pkgconf" => :build
  depends_on "haxe" => :test
  depends_on "jpeg-turbo"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libuv"
  depends_on "libvorbis"
  depends_on "mbedtls"
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
    haxebin = formula_opt_bin("haxe")

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
