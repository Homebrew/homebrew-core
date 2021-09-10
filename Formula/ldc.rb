class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.27.1/ldc-1.27.1-src.tar.gz"
  sha256 "93c8f500b39823dcdabbd73e1bcb487a1b93cb9a60144b0de1c81ab50200e59c"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "a08707a392ab7328a11f2534ce7831b41c082da562593071eff4cd2c97e05940"
    sha256 big_sur:       "105e995ace02a6d41a833f1405192d0f7551c4b74d11760c69cf95eaa77c5518"
    sha256 catalina:      "858571e2c58d67e0fe05f94182fcff9249dd09bc56ad0c6b5f20c54065a5987d"
    sha256 mojave:        "7d36db8c9ff855a75fa5c93c992d7269e836b2562aece4de20185df77fbf04f4"
    sha256 x86_64_linux:  "a0df8131a2a5bb4a829714f880287447f50db1fef119caadf840a227c8024594"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "libxml2" => :build

  fails_with :gcc

  resource "ldc-bootstrap" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://github.com/ldc-developers/ldc/releases/download/v1.27.1/ldc2-1.27.1-osx-x86_64.tar.xz"
        sha256 "52d9958c424683d93c61c791029934df6812f32f76872c6647269e8a55939e6b"
      else
        url "https://github.com/ldc-developers/ldc/releases/download/v1.27.1/ldc2-1.27.1-osx-arm64.tar.xz"
        sha256 "d9b5a4c1dbcde921912c7a1a6a719fc8010318036bc75d844bafe20b336629db"
      end
    end

    on_linux do
      # ldc 1.27 requires glibc 2.27, which is too new for Ubuntu 16.04 LTS.  The last version we can bootstrap with
      # is 1.26.  Change this when we migrate to Ubuntu 18.04 LTS.
      url "https://github.com/ldc-developers/ldc/releases/download/v1.26.0/ldc2-1.26.0-linux-x86_64.tar.xz"
      sha256 "06063a92ab2d6c6eebc10a4a9ed4bef3d0214abc9e314e0cd0546ee0b71b341e"
    end
  end

  def install
    ENV.cxx11
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    if OS.linux?
      # Fix ldc-bootstrap/bin/ldmd2: error while loading shared libraries: libxml2.so.2
      ENV.prepend_path "LD_LIBRARY_PATH", Formula["libxml2"].lib
    end

    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      ]

      system "cmake", "..", *args
      system "make"
      system "make", "install"

      if OS.mac?
        # Workaround for https://github.com/ldc-developers/ldc/issues/3670
        cp Formula["llvm"].opt_lib/"libLLVM.dylib", lib/"libLLVM.dylib"
      end
    end
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS
    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=thin", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=full", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
