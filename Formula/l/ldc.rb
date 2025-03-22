class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.40.1/ldc-1.40.1-src.tar.gz"
  sha256 "b643bee2ee6f9819084ef7468cf739257974a99f3980364d20201bc806a4a454"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "679a6edb5cf0936eccf07bfb8911c26d94be9a512031ce56d1279403ff58ef1b"
    sha256                               arm64_sonoma:  "0c413b0142d6a685bc3ce3d2e602fa186c7ccace9fc499da333fab528c55cd6c"
    sha256                               arm64_ventura: "109a5a8abc99967277d3b843328bb226614fa512e933215319014c9ba58c3541"
    sha256                               sonoma:        "a1ed0483de3d6acd31100020c3cf2ba3826f09f2e3182c5151ee15b9651beaf4"
    sha256                               ventura:       "d2b16171d9e8985cff0253cba8c2023bdc8c67a81d9ec7cd48c489e729e58a70"
    sha256                               arm64_linux:   "1241ce5b60b17a80b64a93c0a5d06a367ab6d2f6556e5e27d9b60f770f7bccb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56996dab133b4cfc6997306069b043b4c60ca28554ab4a2e356fd81bd323b7a0"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkgconf" => :build
  depends_on "llvm@19"
  depends_on "zstd"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.40.0/ldc2-1.40.0-osx-arm64.tar.xz"
        sha256 "04ebaaddfadf5b62486914eee511a8cb9e6802a7b413e7a8799d5a7fa1ca5cb4"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.40.0/ldc2-1.40.0-osx-x86_64.tar.xz"
        sha256 "90802f92801b700804b8ba48d8c12128d3724c9dbb6a88811d6c9204fce9e036"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.40.0/ldc2-1.40.0-linux-aarch64.tar.xz"
        sha256 "28d183a99ab9f0790f5597c5c125f41338390f8bed5ed3164138958c18479c82"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.40.0/ldc2-1.40.0-linux-x86_64.tar.xz"
        sha256 "0da61ed2ea96583aa0ccbeb00f8d78983b23d1e87b84a6f2098eb12059475b27"
      end
    end
  end

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.cxx11
    # Fix ldc-bootstrap/bin/ldmd2: error while loading shared libraries: libxml2.so.2
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["libxml2"].opt_lib if OS.linux?
    # Work around LLVM 16+ build failure due to missing -lzstd when linking lldELF
    # Issue ref: https://github.com/ldc-developers/ldc/issues/4478
    inreplace "CMakeLists.txt", " -llldELF ", " -llldELF -lzstd "

    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    args = %W[
      -DLLVM_ROOT_DIR=#{llvm.opt_prefix}
      -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
      -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Don't set CC=llvm_clang since that won't be in PATH,
    # nor should it be used for the test.
    ENV.method(DevelopmentTools.default_compiler).call

    (testpath/"test.d").write <<~D
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    D
    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    with_env(PATH: "#{llvm.opt_bin}:#{ENV["PATH"]}") do
      system bin/"ldc2", "-flto=thin", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
      system bin/"ldc2", "-flto=full", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
    end
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
