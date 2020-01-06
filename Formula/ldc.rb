class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.19.0/ldc-1.19.0-src.tar.gz"
  sha256 "c7056c10ab841762b84ae9ea6ab083b131924d683e1e0d8a18aa496c537213ae"
  revision 1
  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "45aa4a331339761b64fb5f8b4ed14bdf1cca1be6a9fba0afd2dded25198fdd22" => :catalina
    sha256 "b5b3313d4325c90be9a97792a8125852a677ae266ab9c3e7855011049b146696" => :mojave
    sha256 "0a93cdccea7326398bd43d303be8d8faab9e58896f9d595d2b3db1595703b556" => :high_sierra
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
