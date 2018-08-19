class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.11.0/ldc-1.11.0-src.tar.gz"
    sha256 "85464fae47bc605308910afd6cfc6ddeafe95a8ad5b61e2c0c23caff82119f70"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.6/ldc-0.17.6-src.tar.gz"
      sha256 "868b8c07ab697306ea65f0006fc2b6b96db4df226e82f8f11cafbed6fa9ac561"
    end
  end

  bottle do
    sha256 "5a03bf20778603197e065747cd182ba9a566fe7f31f2fd1df0813c6e2c22b066" => :high_sierra
    sha256 "120fffd8b6207218c950f0e3e91eb388ac3926c842eeeb3d395f82c76aff9bf4" => :sierra
    sha256 "1ad3f554d363bf26688e67fe38b94486a47b7c81d152fe2ef4e2d158b95c12ca" => :el_capitan
  end

  head do
    url "https://github.com/ldc-developers/ldc.git", :shallow => false

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc.git",
          :shallow => false,
          :branch => "ltsmaster"
    end
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "llvm"

  def install
    ENV.cxx11
    (buildpath/"ldc-lts").install resource("ldc-lts")

    cd "ldc-lts" do
      mkdir "build" do
        args = std_cmake_args + %W[
          -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        ]
        system "cmake", "..", *args
        system "make"
      end
    end
    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-lts/build/bin/ldmd2
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
