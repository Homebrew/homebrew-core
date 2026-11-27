class Hashlink < Formula
  desc "Virtual machine for Haxe"
  homepage "https://hashlink.haxe.org/"
  url "https://github.com/HaxeFoundation/hashlink/archive/refs/tags/1.16.tar.gz"
  sha256 "c392ce6e1d3670bcb60c85d83a161591707de9cdb6b00b48e79f9ea7807fc5a9"
  license "MIT"
  revision 1
  head "https://github.com/HaxeFoundation/hashlink.git", branch: "master"

  bottle do
    manifest_sha256 "a6c84cfc496b1d8f605d0f14f89f2f9d82f9c4c9f1317dfe63fbda5af94dabd6"
    sha256 cellar: :any, arm64_golden_gate: "5a3f7bb9afc8b15ee6c6b908d5573e5ae79464b3f0570906597e29663481ccdc"
    sha256 cellar: :any, arm64_tahoe:       "d56e01dc93c896bf944bc4bf2681e3b07e21d799b3efe6b76c4782aac1d8220a"
    sha256 cellar: :any, arm64_sequoia:     "8c5c6d5360b4fc4736b2f309a504f4f484ed5df51eb56f305964392597ac407a"
    sha256 cellar: :any, arm64_linux:       "2ae4c203061f11b96a22c58401384d0dad4b908ca8b1d4c7da09c1fba7c1346b"
    sha256 cellar: :any, x86_64_linux:      "31bbf0fa11a130c8caad66cc6c3245afab6fe7b644f1a958104d7f2df7875115"
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
