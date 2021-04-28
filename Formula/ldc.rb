class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.26.0/ldc-1.26.0-src.tar.gz"
  sha256 "c18f4c76869f0196b459dcd6196c7eaea1b097cc422cf3771de394f6c0ef7474"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", shallow: false

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "b77a8eafcd350b25ec3e29a2c768c34f0f3ad322f1d8e60dcee7ea76da923fac"
    sha256 big_sur:       "e9cdbad72f9d7bf0b9efa3ba7776991f2f6096801d86a0fe4a1a180bf7082e31"
    sha256 catalina:      "88b4647fb9e5e172205aed2d9173867c1fc8a7421ece26593075b2f537de41ee"
    sha256 mojave:        "b513d65c9f42d4753dd2e2d15b5b3b5ac7424d33ef037860bea86c55b1d9c7f1"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://github.com/ldc-developers/ldc/releases/download/v1.26.0/ldc2-1.26.0-osx-x86_64.tar.xz"
        sha256 "b5af4e96b70b094711659b27a93406572cbd4ecf7003c1c84445c55c739c06a1"
      else
        url "https://github.com/ldc-developers/ldc/releases/download/v1.26.0/ldc2-1.26.0-osx-arm64.tar.xz"
        sha256 "303930754c819d0f88434813a82122196bf3fe76ea5bd1b0f16d100b540100e6"
      end
    end

    on_linux do
      url "https://github.com/ldc-developers/ldc/releases/download/v1.26.0/ldc2-1.26.0-linux-x86_64.tar.xz"
      sha256 "06063a92ab2d6c6eebc10a4a9ed4bef3d0214abc9e314e0cd0546ee0b71b341e"
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

      on_macos do
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
