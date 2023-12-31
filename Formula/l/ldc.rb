class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.35.0/ldc-1.35.0-src.tar.gz"
    sha256 "6e296993706c76c093e609139aa0b3f8704355fa0f3756f6758d78d44226dfa0"

    depends_on "llvm@16"

    # Backport fix for LTO on macOS Sonoma
    patch do
      url "https://github.com/ldc-developers/ldc/commit/93b9babe8087a9e1ba3a6a76233175d96e1d2f3f.patch?full_index=1"
      sha256 "8756248cb9bb77595325bc46df10fb42fbd940d86611dd8413abb27de6e177cd"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "6f107abd9d2fe3c2c056eb0c784014f0f9d83474abf137661ec700708f408309"
    sha256                               arm64_ventura:  "4fde56c174bf5706918a8cf3098ac9b32e11b0ce5458ef22f449466d9c0218e2"
    sha256                               arm64_monterey: "28e791054c88ff221eada86e604fe089c9747a4987f2a1943bc20dadd4ea4510"
    sha256                               sonoma:         "847f42c946e7a3b5bcfc2716aaebc4cac7b73acc0cf37a9d2f4ec7b6ea4d8472"
    sha256                               ventura:        "9bc86ab038f3294c7f6e4de85b7949a2c25ec5a5d0f692835a7932c4b5b52559"
    sha256                               monterey:       "6e90f8c288e6c595192af337be6f85718fdc76260dac544cc4802d724790486b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1599f85e8b89bdf1f7d15c8dd8480e4889087e0ae7f9901d81272ac53ae8bce"
  end

  head do
    url "https://github.com/ldc-developers/ldc.git", branch: "master"
    depends_on "llvm"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build

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
