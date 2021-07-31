class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.27.0/ldc-1.27.0-src.tar.gz"
  sha256 "f2dc19ad2fffd4fcef2717ccdaf929ed082c57c9c89c05bdaaa6df87b9999e0b"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "9a9096334f694a1dc8fa14239896d756497168f45f1bc1aef9f401f99339713a"
    sha256 big_sur:       "50995b9707525c112c3251a7a93b2be6ec7c1994b32a76dc3ac3ec84dc197cb3"
    sha256 catalina:      "951f37a67f5fe47d96baaafb2549d08011244862a7ab6de747c310c11119b26a"
    sha256 mojave:        "fa6bfcf0d2a2927a3421ebd17443a813655a0b44e2d705dac57e733022f354e6"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://github.com/ldc-developers/ldc/releases/download/v1.27.0/ldc2-1.27.0-osx-x86_64.tar.xz"
        sha256 "a0cb2f1e5f375b991f3a6a93ce0dbcf1e724d8a3d84195ec7bfe93be728f909c"
      else
        url "https://github.com/ldc-developers/ldc/releases/download/v1.27.0/ldc2-1.27.0-osx-arm64.tar.xz"
        sha256 "47922cee3392466686fa2366466640607a0896b96ea8d5995d171fb4b6e9f3ba"
      end
    end

    on_linux do
      url "https://github.com/ldc-developers/ldc/releases/download/v1.27.0/ldc2-1.27.0-linux-x86_64.tar.xz"
      sha256 "bf00f5c3eadf65980dc7d70590cc869f93e289eafbc84a263220795c6067922e"
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
