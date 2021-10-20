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
    sha256 arm64_big_sur: "edba6cdbd6aeec055f9d73e83113d6d9f6ef8283ec5097aa11c542a5b2f42bec"
    sha256 big_sur:       "cfe36977e1b7607e066c3978328195d475be77e040bc8562916e0c0c1edba187"
    sha256 catalina:      "6a26dea81c20e12e65b8d118dff491cb0706374dc32a18beae194062f47b30fb"
    sha256 mojave:        "3b837b63e0bf55c9f61ab69031b5c1b300c2d6f5e5b933418fae4b18630dad1d"
    sha256 x86_64_linux:  "a2892c9dee79469150b022771a5989719ce9494c2d873518541df2b194105478"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@12"

  uses_from_macos "libxml2" => :build
  # CompilerSelectionError: ldc cannot be built with any available compilers.
  uses_from_macos "llvm" => [:build, :test]

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
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match? "^llvm" }
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
