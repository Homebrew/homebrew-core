class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.31.0/ldc-1.31.0-src.tar.gz"
  sha256 "f1c8ece9e1e35806c3441bf24fbe666cddd8eef375592c19cd8fee4701cd5458"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "41889aaf4d473a23d230a285a64bcd91377a24c93bf8ba181dd166449840fba8"
    sha256                               arm64_monterey: "2d2b2218a0f12f356b37b1ec993ebac70a9e3bfdab0377902231866314389653"
    sha256                               arm64_big_sur:  "bab8dac0b6f0f3ccfe5b39c533f8f0a47553f29bfe86cfc963f2d5ac676be196"
    sha256                               ventura:        "d34d3fbf8d3b8069642e6c0f94b50b01963ae59dd6fcde0450864f90dd88e980"
    sha256                               monterey:       "aa6ed611b879d8788f0049b639b198f31ecf9a5af1392fdccb51622b1550a0ca"
    sha256                               big_sur:        "a272354602009b1bbcf13dc5e07590094e6b7de57f0733ef0bfff1f06070775d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23b971f1555b91d3e5954938b8eca74b8633cac74ede10be9ed3de2505b17135"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@14" # LLVM 15 issue: https://github.com/ldc-developers/ldc/issues/4042

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.1/ldc2-1.28.1-osx-arm64.tar.xz"
        sha256 "9bddeb1b2c277019cf116b2572b5ee1819d9f99fe63602c869ebe42ffb813aed"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.1/ldc2-1.28.1-osx-x86_64.tar.xz"
        sha256 "9aa43e84d94378f3865f69b08041331c688e031dd2c5f340eb1f3e30bdea626c"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.1/ldc2-1.28.1-linux-aarch64.tar.xz"
        sha256 "158cf484456445d4f59364b6e74881d90ec5fe78956fc62f7f7a4db205670110"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.1/ldc2-1.28.1-linux-x86_64.tar.xz"
        sha256 "0195172c3a18d4eaa15a06193fea295a22e21adbfbcb7037691c630f191bceb2"
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
      ENV.prepend_path "LD_LIBRARY_PATH", Formula["libxml2"].opt_lib
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
