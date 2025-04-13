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
    sha256                               arm64_sequoia: "bf62f0e0c7a7eb72db23404decbcb150d0e45b1562db44df733fc7f325c76d44"
    sha256                               arm64_sonoma:  "4d22f4d7c6623ceea882c608f008218b96deac008d5e2902c34ccc79fb8df50a"
    sha256                               arm64_ventura: "ef232af8cbe6880220437658f33e946d899f880da8f726d21a23e3d0720ffff5"
    sha256                               sonoma:        "bc74c7e7324ee29cc9eb33f8c3580ba4185640bc28c0515aa82603657f02d64f"
    sha256                               ventura:       "aac0761e4cba1a2dbb862cd2f3b4e3899bd76e6738016cb24f33885eef355c73"
    sha256                               arm64_linux:   "2b685946656c81c99e5a1ce6a2c4b8ef77c320cda2bb0a3f33638dd7e7a5d345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b644f70c0fa431945753c3bd4cc59f02febdc4569a17517fca3f0e6e7e9c0ba"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkgconf" => :build
  depends_on "lld@19" => :test
  depends_on "llvm@19" # LLVM 20 PR: https://github.com/ldc-developers/ldc/pull/4843
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
    lld = deps.map(&:to_formula).find { |f| f.name.match?(/^lld(@\d+(\.\d+)*)?$/) }
    with_env(PATH: "#{lld.opt_bin}:#{ENV["PATH"]}") do
      system bin/"ldc2", "-flto=thin", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
      system bin/"ldc2", "-flto=full", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
    end
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
