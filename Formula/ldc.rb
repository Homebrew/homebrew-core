class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.30.0/ldc-1.30.0-src.tar.gz"
  sha256 "fdbb376f08242d917922a6a22a773980217fafa310046fc5d6459490af23dacd"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "703a1b7cc6dea61112183cbc21cd77faf686a7527b105bb61db7e3d92c0bd6a6"
    sha256 arm64_big_sur:  "660bc67a5e12896a19427be2f39d58fad9f2c78d3f5948792706d20e80f351db"
    sha256 monterey:       "c2b1c19deb39e815c8f1ddf0f8f1fdab63e849e6777c7e3e092399f3891110b1"
    sha256 big_sur:        "c3fbdc34a89752a66e633ace1416e4f31eec1e4067f37d2cd12855323a068e15"
    sha256 catalina:       "574931fec5e3746c83d7fb67a25af715d8c51efde11f70a48d037abecf2824ea"
    sha256 x86_64_linux:   "7e532a02f6949cfc57355eb5c35b0f438e955db551dd5a98833d621be58a51fd"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "libxml2" => :build

  fails_with :gcc

  resource "ldc-bootstrap" do
    on_macos do
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.1/ldc2-1.28.1-osx-x86_64.tar.xz"
        sha256 "9aa43e84d94378f3865f69b08041331c688e031dd2c5f340eb1f3e30bdea626c"
      end

      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.1/ldc2-1.28.1-osx-arm64.tar.xz"
        sha256 "9bddeb1b2c277019cf116b2572b5ee1819d9f99fe63602c869ebe42ffb813aed"
      end
    end

    on_linux do
      # ldc 1.27 requires glibc 2.27, which is too new for Ubuntu 16.04 LTS.  The last version we can bootstrap with
      # is 1.26.  Change this when we migrate to Ubuntu 18.04 LTS.
      url "https://github.com/ldc-developers/ldc/releases/download/v1.26.0/ldc2-1.26.0-linux-x86_64.tar.xz"
      sha256 "06063a92ab2d6c6eebc10a4a9ed4bef3d0214abc9e314e0cd0546ee0b71b341e"
    end
  end

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.cxx11
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    args = %W[
      -DLLVM_ROOT_DIR=#{llvm.opt_prefix}
      -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
      -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
    ]

    args += if OS.mac?
      ["-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib, target: llvm.opt_lib)}"]
    else
      # Fix ldc-bootstrap/bin/ldmd2: error while loading shared libraries: libxml2.so.2
      ENV.prepend_path "LD_LIBRARY_PATH", Formula["libxml2"].lib if OS.linux?

      gcc = Formula["gcc"]
      # Link to libstdc++ for brewed GCC rather than the host GCC which is too old.
      libstdcxx_lib = gcc.opt_lib/"gcc"/gcc.version.major
      linux_linker_flags = "-L#{libstdcxx_lib} -Wl,-rpath,#{libstdcxx_lib}"

      # Use libstdc++ headers for brewed GCC rather than host GCC which is too old.
      libstdcxx_include = gcc.opt_include/"c++"/gcc.version.major
      linux_cxx_flags = "-nostdinc++ -isystem#{libstdcxx_include} -isystem#{libstdcxx_include}/x86_64-pc-linux-gnu"

      %W[
        -DCMAKE_EXE_LINKER_FLAGS=#{linux_linker_flags}
        -DCMAKE_MODULE_LINKER_FLAGS=#{linux_linker_flags}
        -DCMAKE_SHARED_LINKER_FLAGS=#{linux_linker_flags}
        -DCMAKE_CXX_FLAGS=#{linux_cxx_flags}
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Don't set CC=llvm_clang since that won't be in PATH,
    # nor should it be used for the test.
    ENV.method(DevelopmentTools.default_compiler).call

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
