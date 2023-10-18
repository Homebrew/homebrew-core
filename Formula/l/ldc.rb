class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.35.0/ldc-1.35.0-src.tar.gz"
  sha256 "6e296993706c76c093e609139aa0b3f8704355fa0f3756f6758d78d44226dfa0"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "61a80e7ce250c8fd2753f99a0ae8dc6f08e37e1ba7370acd4529e545ad5bd6a7"
    sha256                               arm64_monterey: "d8050f0b00b323157701942def9367ddf959993807a019fd1dfb294c0e823cbc"
    sha256                               ventura:        "2475db77771ad577dba5009020d923eb847a0646c54b94b1386f0816c849b61e"
    sha256                               monterey:       "d4f10edfad963f9f2faed2d34b366ae19691b702bbced262194e3fe4bac09536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5b5aa12699b0c8e640f73c1175924a60cd55b4bf4faa4e60480791e0a59d787"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  # llvm@16 build failure report, https://github.com/ldc-developers/ldc/issues/4478
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
    # Fix ldc-bootstrap/bin/ldmd2: error while loading shared libraries: libxml2.so.2
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["libxml2"].opt_lib if OS.linux?

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
