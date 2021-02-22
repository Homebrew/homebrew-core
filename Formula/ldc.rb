class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.25.0/ldc-1.25.0-src.tar.gz"
  sha256 "6466441698f07ff00dfa7eadee1b9885df8698dbfd70bd9744bd1881ab466737"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", shallow: false

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 big_sur:  "2f55c8a8f0a3c3c9a46d3d56792b539d663cbf889274ae0bc21a57002c6344c9"
    sha256 catalina: "c55b6dad0e09b8422d0544be364514489a1a0dea9aff57c72f769bf8d1c0ad61"
    sha256 mojave:   "831e1e40027197d94e97670073d7a08fef68e464c5b5165d68ae670964d2e2be"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://github.com/ldc-developers/ldc/releases/download/v1.25.0/ldc2-1.25.0-osx-x86_64.tar.xz"
        sha256 "ea22a76d2fa86a52ca9b24bca980ffc12db56fbf8ef9582c586da24f83eb58f5"
      else
        url "https://github.com/ldc-developers/ldc/releases/download/v1.25.0/ldc2-1.25.0-osx-arm64.tar.xz"
        sha256 "3bfc74bf2d30c1015a0dce2e59278c871f9c8492aa6d06fa7b940d61ffbb0c2c"
      end
    end

    on_linux do
      url "https://github.com/ldc-developers/ldc/releases/download/v1.25.0/ldc2-1.25.0-linux-x86_64.tar.xz"
      sha256 "b1f838ed1765b08a6bc9cde266f135eceb4bc1e877670e837ae349620a6e1fea"
    end
  end

  def install
    ENV.cxx11
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      ]

      system "cmake", "..", *args
      system "make"
      system "make", "install"

      # Workaround for https://github.com/ldc-developers/ldc/issues/3670
      cp Formula["llvm"].opt_lib/"libLLVM.dylib", lib/"libLLVM.dylib"
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
