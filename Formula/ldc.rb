class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"

  stable do
    # for the sake of LLVM 3.9 compatibility
    url "https://github.com/ldc-developers/ldc.git",
        :branch => "release-1.0.1",
        :revision => "3461e00f3531f855f9fc6e92515d7affb8201827"
    version "1.0.1-alpha1"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.2/ldc-0.17.2-src.tar.gz"
      sha256 "8498f0de1376d7830f3cf96472b874609363a00d6098d588aac5f6eae6365758"
    end
  end

  bottle do
    sha256 "5d4e2c20dd74909113448f9d80032b9eea9776061c2aabde9b58d33b36503588" => :sierra
    sha256 "4837cf9fdb9b9c030fb26674254a844610459203a79847b1ff3cf0d85770fc33" => :el_capitan
    sha256 "8d827625dea278303befcbb997d3e1713b7d85e257705a30da72ce1519eab147" => :yosemite
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.1.0-beta5/ldc-1.1.0-beta5-src.tar.gz"
    sha256 "46c494ca1c29f2cd1e5d2e2d29681ceeb71fad72f34cc8d2308856c22b27a41b"
    version "1.1.0-beta5"

    patch do
      url "https://github.com/ldc-developers/ldc/pull/1902.patch"
      sha256 "dcb61bb49a56537f77d9153b687a591a48129bb1cb5ac30d7df78cd251431e6d"
    end

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.2/ldc-0.17.2-src.tar.gz"
      sha256 "8498f0de1376d7830f3cf96472b874609363a00d6098d588aac5f6eae6365758"
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
      unless build.stable?
        lib.install bin/"libLTO-ldc.dylib"
      end
    end
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS

    if build.stable?
      system bin/"ldc2", "test.d"
    else
      system bin/"ldc2", "-flto=full", "test.d"
    end
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
