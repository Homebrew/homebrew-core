class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.24.0/ldc-1.24.0-src.tar.gz"
  sha256 "fd9561ade916e9279bdcc166cf0e4836449c24e695ab4470297882588adbba3c"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", shallow: false

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "50fbf7f844bdbf0b7ddadfd4e028509192fe0c12f7c2dfafd57158d649856a82" => :catalina
    sha256 "fbb02c825000d7e2d68061d390279769eb0ee332f8dffc5fabb405e42df0dee6" => :mojave
    sha256 "64cd2a36a85803fe72ee075f35b1a71d4e5f3ddf06115c8885df72874abfec0d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "llvm@9" # due to a bug in llvm 10 https://bugs.llvm.org/show_bug.cgi?id=47226

  uses_from_macos "libxml2" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "ldc-bootstrap" do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.24.0/ldc2-1.24.0-osx-x86_64.tar.xz"
    sha256 "91b74856982d4d5ede6e026f24e33887d931db11b286630554fc2ad0438cda44"
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
