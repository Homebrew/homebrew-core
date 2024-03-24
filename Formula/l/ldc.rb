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
    sha256                               arm64_sonoma:   "a6608742b2a6463f7e3679d007c6767178ae37545a5c6b45808afaf168bacaad"
    sha256                               arm64_ventura:  "a45760c5605c942fa57c120a5e4872340768dbf03231e8ab60e0aff048de199e"
    sha256                               arm64_monterey: "b4211bd6f90b1e79e56b0c079dcd6df4c9fee40f855893d58135159624ef2749"
    sha256                               sonoma:         "0c32c34dd6547a57cc9b7e5314a7dd67329a2acce72efcbe11a0a408026a217e"
    sha256                               ventura:        "1b349064dc40cd433413262044ffd1b6d037a4c790bdf6dad294dc13d041bd7c"
    sha256                               monterey:       "ae0dd916281e3ce60fa7b4d11f77b38290afb4a8609bb427adac5fc81c3c86a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c001131cb1b1b7bfc8fe09d00d20e384ab9e636828aa75caaf053b10e59d4c82"
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
