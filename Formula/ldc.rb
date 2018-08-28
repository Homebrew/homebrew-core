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
    sha256 "0995bbd559274edf5ca88e702f0eca2dadec42804f5e7a11d6708447474c3663" => :high_sierra
    sha256 "6e0fd2df7225ce4595ce4bb0003ceff4d0d63aef713d2a283192216467bd4696" => :sierra
    sha256 "5d0dcb4e222e1586d4d3d9cbb9a106f70d07d150f64e73cb6daa864e815229af" => :el_capitan
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
