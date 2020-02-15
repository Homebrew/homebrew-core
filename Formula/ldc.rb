class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.20.0/ldc-1.20.0-src.tar.gz"
  sha256 "49c9fdfe3a51c978385aae94f2e102f306102f6282215638f2ae3fb9ea8d3ab9"
  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "13ad6423ce88a458552b0cbc6c41cc2772a19251be6ccf5ed5e3e9c068e22348" => :catalina
    sha256 "7d7597d7055ee4167733d29e74857247e66558a547b9b864caffe434af358d4b" => :mojave
    sha256 "b4e4f77ef64ef061911331b2d8dc52cbee18892bf1c4bb7d6b19bbe3cf43e492" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "llvm"

  resource "ldc-bootstrap" do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.20.0/ldc2-1.20.0-osx-x86_64.tar.xz"
    version "1.20.0"
    sha256 "00827edaf43b4f7a3bf5117d2a6b8cb3cae0e7b167782d2d41bce078804fc769"
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
