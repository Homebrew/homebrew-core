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
    sha256 big_sur:  "1119d5cc607c3fc90894a455a762cf027908cdaeb0ab3fe44a992307a0d55cd6"
    sha256 catalina: "d0b2bf9ec8d3824fc0ab94ef8ef221ac360da96ae24ad5760e352cfc15210b58"
    sha256 mojave:   "5181a61b98424bbfa7da8d7fd8392b7dabe48a2aa609ecaf109408760ca09808"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "llvm"

  uses_from_macos "libxml2" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "ldc-bootstrap" do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.25.0/ldc2-1.25.0-osx-x86_64.tar.xz"
    sha256 "ea22a76d2fa86a52ca9b24bca980ffc12db56fbf8ef9582c586da24f83eb58f5"
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
