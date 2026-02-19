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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fec6262dd3d0fd5fd4b193897f7fc621d43c15566d857ce63bdee05ea1011898"
    sha256 cellar: :any,                 arm64_sequoia: "66da51020a5d2c176526de2f58ac48c2441d2cbe96015eccba24d9bae04ffaf5"
    sha256 cellar: :any,                 arm64_sonoma:  "5255cb6165cc8da050a92300ba4ff31799b66a2946a6c0e64e113d936285585a"
    sha256 cellar: :any,                 sonoma:        "edbce7ca0eb456f8bf1d24de717897d368a7d353cc581edf30a218e368c8c2bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332b1aaba5e901a3bc4a0b2598a64bcb6cfed54743d29071c3326c85ace4a974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a9d6651f89c3b934532d246176249522e8aaf42658dea4bd09d67f3a5c2107f"
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
