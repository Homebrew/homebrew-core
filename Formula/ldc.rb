class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  revision 2

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.1.1/ldc-1.1.1-src.tar.gz"
    sha256 "3d35253a76288a78939fea467409462f0b87461ffb89550eb0d9958e59eb7e97"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.4/ldc-0.17.4-src.tar.gz"
      sha256 "48428afde380415640f3db4e38529345f3c8485b1913717995547f907534c1c3"
    end
  end

  bottle do
    sha256 "f37e3efb0fda9dee9efaca65fe8085d01ee2e9bab9f7b4796c8b5dd9a7eb18b7" => :sierra
    sha256 "8a49c6463d3056ebf935d3ef6eff9d2745e1f38c16022e6a2b561e8769c9c64c" => :el_capitan
    sha256 "207ba64c9defcf4d52bc917927c93fb6278a6ad67f306be2278e18adecf68205" => :yosemite
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.2.0-beta2/ldc-1.2.0-beta2-src.tar.gz"
    sha256 "33388995c4a3dfcd34d77d2cd5759ae35c7636ebdcc65d71ba6e4f4736c4fcb1"
    version "1.2.0-beta2"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.4/ldc-0.17.4-src.tar.gz"
      sha256 "48428afde380415640f3db4e38529345f3c8485b1913717995547f907534c1c3"
    end
  end

  head do
    url "https://github.com/ldc-developers/ldc.git", :shallow => false

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc.git", :shallow => false, :branch => "ltsmaster"
    end
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "libconfig"

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
      ]

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS

    system bin/"ldc2", "-flto=full", "test.d"

    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
