class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.38.0/ldc-1.38.0-src.tar.gz"
  sha256 "ca6238efe022e34cd3076741f8a070c6a377196351c61949a48a48c99379f38e"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "95844acab6441d928fd95b8e408668c734392a83a4d317fef59193095a5ae358"
    sha256                               arm64_ventura:  "4a187abbcef9fdddf26704e2cfe6e8497c0ddaa50ac358a7fce1156f2888b783"
    sha256                               arm64_monterey: "6e9aaa4d4ac5d7bb17680d5a1e2c55ce89d224153e52a77a143ebd8b840259d3"
    sha256                               sonoma:         "36961228c3aacd893a9b8ced838ac884b65e77e049e48242ec99b604dfe65c91"
    sha256                               ventura:        "18505f725af1fa492fe8570bb0536c213f4db4835e4c70a29d04cd59aa6e4655"
    sha256                               monterey:       "09564b1b6d9e0a86ebd65095a001315c75063529e0becb061c3f45508b1d5b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31f5610e48ed3be9f85bc5979d6345fbe388481438054fa92b7e755114523f71"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.38.0/ldc2-1.38.0-osx-arm64.tar.xz"
        sha256 "bfcad81853462a1308c045f1c82b641c3ac007000c5f7de269172067e60a6dea"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.38.0/ldc2-1.38.0-osx-x86_64.tar.xz"
        sha256 "d52e1bc5634f045528083d5088b8cfb936b5ab9c041aaaa604902dbf82eef76b"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.38.0/ldc2-1.38.0-linux-aarch64.tar.xz"
        sha256 "3d17aae84f7500a0e0ad5a3b6a4c6398415d2a4cd330216a4b15a3b4d3a2edea"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.38.0/ldc2-1.38.0-linux-x86_64.tar.xz"
        sha256 "e5108a5ae7ca135623f79569182929a2aab117767a6fb85b599338648b7e7737"
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

    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS
    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    with_env(PATH: "#{Formula["llvm"].opt_bin}:#{ENV["PATH"]}") do
      system bin/"ldc2", "-flto=thin", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
      system bin/"ldc2", "-flto=full", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
    end
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
