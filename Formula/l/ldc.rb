class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.37.0/ldc-1.37.0-src.tar.gz"
  sha256 "50e80ae3c436c90637c2c3d40f392dc28b721f7aab3a1e3ca3bf4f9c28dba064"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "51b4aee5496152d31820a0e0b987fa4cebc2c20e123a24f9502abb6b95def810"
    sha256                               arm64_ventura:  "0efc0c05f698b21fb3c9fa833defb3d8e3662353245590ff7cd33d448c2dd952"
    sha256                               arm64_monterey: "0650053126f508f56396f327edda6c45426029dbd0c682502676b3c2d38e04cb"
    sha256                               sonoma:         "54da9a6c61d0a10a1fea8fcc0e0daef2a0d4e2a8313e22f647e1cd6587fc5a06"
    sha256                               ventura:        "c2e51f753ad78a81e1c8e3eaa8f77500220bafcf4a2cbe72746721858640c6f5"
    sha256                               monterey:       "238df916f382e60216b7535e01abcb608cb3c9e9cfa7051b4a4776b1af2698ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ec35e481c34e435cf98f4deffd6634c816b134f403a5c36bb15289830eefbb8"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@17"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.37.0/ldc2-1.37.0-osx-arm64.tar.xz"
        sha256 "e8e715e185a4086c0771299b418956a5cfb5759679514eaee55a0c59a84571c7"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.37.0/ldc2-1.37.0-osx-x86_64.tar.xz"
        sha256 "6cc65f7edc8e753b059062d1652d7eb299a122235bde1cce4878ae1cfae09ae2"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.37.0/ldc2-1.37.0-linux-aarch64.tar.xz"
        sha256 "6b1b740002bea1be67f758f9e40c1c629d08903062c6bf83b93af3b13b962c9f"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.37.0/ldc2-1.37.0-linux-x86_64.tar.xz"
        sha256 "55524bf320fcc7ed453c29a07e9a98a1716f278dbab7ba4c156dc2719b4671df"
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
    system bin/"ldc2", "-flto=thin", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=full", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
