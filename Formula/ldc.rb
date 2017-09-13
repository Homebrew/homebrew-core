class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  revision 1

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.3.0/ldc-1.3.0-src.tar.gz"
    sha256 "efe31a639bcb44e1f5b752da21713376d9410a01279fecc8aab8572065a3050b"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.4/ldc-0.17.4-src.tar.gz"
      sha256 "48428afde380415640f3db4e38529345f3c8485b1913717995547f907534c1c3"
    end

    depends_on "libconfig"
  end

  bottle do
    sha256 "0a3d8bd18fbfd865e116e4090650bb6b1e8d89daa9098621986fb9b5130c04ef" => :sierra
    sha256 "5786ac60b7433bc8bcc665199e4e4d5d2be0141867581085c74314c240eae3a4" => :el_capitan
    sha256 "74f8b7e12efd094cc936db11f948629708775d2f8369957fe2d5a67221a92ea2" => :yosemite
  end

  head do
    url "https://github.com/ldc-developers/ldc.git", :shallow => false

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc.git", :shallow => false, :branch => "ltsmaster"
    end
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "llvm@4"

  def install
    ENV.cxx11
    (buildpath/"ldc-lts").install resource("ldc-lts")

    cd "ldc-lts" do
      mkdir "build" do
        args = std_cmake_args + %W[
          -DLLVM_ROOT_DIR=#{Formula["llvm@4"].opt_prefix}
        ]
        system "cmake", "..", *args
        system "make"
      end
    end
    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm@4"].opt_prefix}
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
