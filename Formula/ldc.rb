class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.13.0/ldc-1.13.0-src.tar.gz"
  sha256 "4b2fd3eb90fb6debc0ae6d70406bc78fcb531a0f20806640e626d4822e87b2e0"
  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "08390a0dc2fd046152aadf76fbd1de2e38c1c9dfb7373696dd92dafa31ad137e" => :mojave
    sha256 "876f04436441623dea0622b09742444b8b938f809f06634a6d6d0feb164d291f" => :high_sierra
    sha256 "73e5d71a5e36a6c9d501badef4eac74f39df8212f95278eda0f6c5f49ca1cfc2" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "llvm"

  resource "ldc-bootstrap" do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.12.0/ldc2-1.12.0-osx-x86_64.tar.xz"
    version "1.12.0"
    sha256 "a946e658aaff1eed80bffeb4d69b572f259368fac44673731781f6d487dea3cd"
  end

  needs :cxx11

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
