class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.25.1/ldc-1.25.1-src.tar.gz"
  sha256 "0e3716fe9927be91264d1fde5c41071026f6c44262735e9ebda538089b612d40"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", shallow: false

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "4357ba0f0d76fe7a47f4d104719da05748eb7b2ff8c60759361930d7e282ef77"
    sha256 big_sur:       "2f55c8a8f0a3c3c9a46d3d56792b539d663cbf889274ae0bc21a57002c6344c9"
    sha256 catalina:      "c55b6dad0e09b8422d0544be364514489a1a0dea9aff57c72f769bf8d1c0ad61"
    sha256 mojave:        "831e1e40027197d94e97670073d7a08fef68e464c5b5165d68ae670964d2e2be"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://github.com/ldc-developers/ldc/releases/download/v1.25.1/ldc2-1.25.1-osx-x86_64.tar.xz"
        sha256 "ebf4ad51959e5845cb56a8b860b6619f44022186b06c28f0942272f5eb3d54c4"
      else
        url "https://github.com/ldc-developers/ldc/releases/download/v1.25.1/ldc2-1.25.1-osx-arm64.tar.xz"
        sha256 "bb39aa145f74ff033423f06d43dbc26f9d650fe3794764bc938abef4bf1ca7f5"
      end
    end

    on_linux do
      url "https://github.com/ldc-developers/ldc/releases/download/v1.25.1/ldc2-1.25.1-linux-x86_64.tar.xz"
      sha256 "d059c853db0313d9cdbc6c5c0f021b60e150f19ae68b4c53251ad0292767c095"
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
