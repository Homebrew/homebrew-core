class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.19.0/ldc-1.19.0-src.tar.gz"
  sha256 "c7056c10ab841762b84ae9ea6ab083b131924d683e1e0d8a18aa496c537213ae"
  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "d1a3c150b95503558ef83d8e6dfdad818fa550b97333368178e402ab13cc02fc" => :mojave
    sha256 "ae7b85fa800d95dcc8815dfafd5716b0d3cf47134d2fc536a2796db8cee11f28" => :high_sierra
    sha256 "f48a3181863ba8a69c56459512a15fb1f0fcc153250d3cba5374c173a3627d31" => :sierra
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
        -DLDC_WITH_LLD=OFF
        -DRT_ARCHIVE_WITH_LDC=OFF
      ]
      # LDC_WITH_LLD see https://github.com/ldc-developers/ldc/releases/tag/v1.4.0 Known issues
      # RT_ARCHIVE_WITH_LDC see https://github.com/ldc-developers/ldc/issues/2350

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
