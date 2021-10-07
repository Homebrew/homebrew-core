class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.27.1/ldc-1.27.1-src.tar.gz"
  sha256 "93c8f500b39823dcdabbd73e1bcb487a1b93cb9a60144b0de1c81ab50200e59c"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/ldc-developers/ldc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "723b7395eef711a988dd2e644c105303222c66de9e3ec3d651fead70d0beaa15"
    sha256 big_sur:       "40344cb91c6fbce6d35bf779d1006063cb6a983471c9fb77f1709091da6e20be"
    sha256 catalina:      "087d2442fbc40af6af86037941ab77cabf674a40a7e9b6cb7abdd6fdba41f8cb"
    sha256 mojave:        "3018868df975db5a608d56b0a8a470e58c93fea77819000b5f5a76d93b1da5c8"
    sha256 x86_64_linux:  "33d9caca71dcc5ac8c2f9caecd1225ff8d05ff68b5da9d183e4f5d2b8a0b3125"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@12"

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

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
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
        -DLLVM_ROOT_DIR=#{llvm.opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      ]
      args << "-DCMAKE_INSTALL_RPATH=#{rpath};@loader_path/#{llvm.opt_lib.relative_path_from(lib)}" if OS.mac?

      system "cmake", "..", *args
      system "make"
      system "make", "install"
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
