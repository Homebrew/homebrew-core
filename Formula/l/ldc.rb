class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.41.0/ldc-1.41.0-src.tar.gz"
  sha256 "af52818b60706106fb8bca2024685c54eddce929edccae718ad9fbcf689f222f"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "96c0f02aeb8b0fce7754eb723fdaa3d6cc09e12b5f58bccc242ae5b8c10eaa30"
    sha256                               arm64_sequoia: "f0c2dbbdcae4b980065505ff72a20a0a29dae7dfe8afdeb7a94711d8e6dd46fc"
    sha256                               arm64_sonoma:  "547c3c670bf11396c3efdb637133fdfcc75b392b6ea0b191060e4fbfac44cd36"
    sha256                               arm64_ventura: "741d5a458d0b7eba1166852d930a2f5ed2b0c6d473693b715ac8cafc412b6805"
    sha256                               sonoma:        "b289f81361bd6543932310bd415a083b8591ba9cf63c5d2a7b8fa601cb17d678"
    sha256                               ventura:       "a7b1ee1863969e05c904f83ae66a796b19b10ac3518e0c7522735876bf6cf80e"
    sha256                               arm64_linux:   "c9538d69c75aeb7b4c4f79272159b8cb441d9758a8d1f08e7e91ba65f10dc838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6cfe190526020bdb7f2d6d6e2f1b633f330317d747262e71b5a493eef733d43"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkgconf" => :build
  depends_on "lld@20" => :test
  depends_on "llvm@20"
  depends_on "zstd"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      # Do not use 1.29 - 1.40 to bootstrap as it segfaults on macOS 15.4.
      # Ref: https://github.com/dlang/dmd/issues/21126#issuecomment-2775948553
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
