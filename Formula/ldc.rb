class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.13.0/ldc-1.13.0-src.tar.gz"
  sha256 "4b2fd3eb90fb6debc0ae6d70406bc78fcb531a0f20806640e626d4822e87b2e0"
  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "e8d5c6d1885ae7eec4ad00dfca617d9d9cdc974a0c8b04a713e05720a44021d6" => :mojave
    sha256 "75763bcd5a66bd46d5e2812a6d4f021b3402a410fd72547f45c9d860c3534aeb" => :high_sierra
    sha256 "c41918db0723f2da8d9348286ebb2ba5500161a6221b12de838a9e7452c11631" => :sierra
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
