class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.32.1/ldc-1.32.1-src.tar.gz"
  sha256 "b3553bfaa89524317ecd21eb2c63c6ea0f9a7080a16275e46fda7e3ab357ea0f"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "884908eb524e1534d052f9b3ba27e2ff4e83a3c9438ae7ad1881b37c23d51d1d"
    sha256                               arm64_monterey: "ae960c4056c9961c181642fc5ca91d0827c6bb832f96eccfdcba40ab6a106212"
    sha256                               arm64_big_sur:  "0340604e18d4844af7505abeb7af95fb6b82f8ab2b1a907dce4ae72a73a4503c"
    sha256                               ventura:        "549887c31dd69502f6986f13d7e3fe1b70afdbd1f81c97699559db0cb04e3cb9"
    sha256                               monterey:       "0220d5ee25de7ad87fe05dec8a4adbe0c867bdfda1ff1b7f7f36595f1409f99b"
    sha256                               big_sur:        "3d09f7d504d54ef85657862b0e72b2a035112b2af8e5a3ca2c3366c2f329ddbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afbc4ea70ed42df80401245c9105ccc5c4e16e16232c2d3f5837c54d4f3e0a8c"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  # TODO: Check if the latest `llvm` can be used:
  #   https://github.com/ldc-developers/ldc/blob/v#{version}/cmake/Modules/FindLLVM.cmake
  depends_on "llvm@15"

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
