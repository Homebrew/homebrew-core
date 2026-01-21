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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8e5a71b5aa8517f8d5dbecc2f5ccb41b903532663ae673e1470f0bb542470e1"
    sha256 cellar: :any,                 arm64_sequoia: "76271bda73f86f73548ee686f1cd1077d9a74c52f0efde4f691218d190f5c666"
    sha256 cellar: :any,                 arm64_sonoma:  "1b30d3767d3eb7794776235993e1389b25aef4630bed5dd2e40a49e985983d60"
    sha256 cellar: :any,                 sonoma:        "e5052135ebcd62e610d2e672c4461880e4b9230def0ae4d9fb73b7db703c1ac8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56507c5d62965324d6b3d55ae92d24489ec8ddb035f1a15f35ba88bef12897b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a48b167dff041ff2080ec6c885ff94deae5a581677117ee69dbff14af9c91a"
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
