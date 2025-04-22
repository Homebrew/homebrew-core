class Hashlink < Formula
  desc "Virtual machine for Haxe"
  homepage "https://hashlink.haxe.org/"
  license "MIT"
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
    sha256 cellar: :any,                 arm64_sequoia: "88ce0382363f5995731d0fc498aa87d0e3a63e5e1df9dcb850f9aae11f47ce4f"
    sha256 cellar: :any,                 arm64_sonoma:  "74702f549d40fa1f1ca50bab1bf403f99b2ed87e2ff6ae9db26ee6ac417b4668"
    sha256 cellar: :any,                 arm64_ventura: "97f8de5f331d21b2d857282e6b3bed1d8b47fd02c3e77aedb789b9711088aee9"
    sha256 cellar: :any,                 sonoma:        "99ef63e02f0bbb6a3e54b02319796fed5660f992ee0e1dbe9097239044ad4faa"
    sha256 cellar: :any,                 ventura:       "f7e72d266dc1e415280ee163dcbcc8ef6802751e8469229da7c75653b621dca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "032ad206b3a17a214c1c0d0cf8256b7882b1d962306dd8ab5ca7f39c4e3fdc99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7e70f6faae35bb958d819576c54d06d9852415cbbc5e98c8846db377a83eed8"
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
