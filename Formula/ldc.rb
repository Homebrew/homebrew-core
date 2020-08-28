class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.23.0/ldc-1.23.0-src.tar.gz"
  sha256 "6d18d233fb3a666113827bdb7d96a6ff0b54014bbeb76d0cd12a892e8490afb9"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", shallow: false

  livecheck do
    url "https://github.com/ldc-developers/ldc/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "1c3b260fe74079e4da13db6bfbc7be9e87708b2a671677ec74528e4f79593e14" => :catalina
    sha256 "1375459c29bd65dac8dd45c474bfda0eb6a28b5ce1d4c331b99ce9322afe3988" => :mojave
    sha256 "3ca0713b249bb1a1401485b54f22784386e350c5a13727c492dbe2b0fa42779c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "llvm@9" # due to a bug in llvm 10 https://bugs.llvm.org/show_bug.cgi?id=47226

  uses_from_macos "libxml2" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "ldc-bootstrap" do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.23.0/ldc2-1.23.0-osx-x86_64.tar.xz"
    version "1.23.0"
    sha256 "b3a6ec50f83063a66d5d538c635b1d1efc454bd8f2f8d74adaa93c36e1566dab"
  end

  def install
    ENV.cxx11
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm@9"].opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      ]

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
