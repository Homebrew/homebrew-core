class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.19.0/ldc-1.19.0-src.tar.gz"
  sha256 "c7056c10ab841762b84ae9ea6ab083b131924d683e1e0d8a18aa496c537213ae"
  revision 1
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
    url "https://github.com/ldc-developers/ldc/releases/download/v1.19.0/ldc2-1.19.0-osx-x86_64.tar.xz"
    version "1.19.0"
    sha256 "c7bf6facfa61f2e771091b834397b36331f5c28a56e988f06fc4dc9fe0ece3ae"
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
