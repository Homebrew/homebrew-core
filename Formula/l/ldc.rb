class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.40.1/ldc-1.40.1-src.tar.gz"
    sha256 "b643bee2ee6f9819084ef7468cf739257974a99f3980364d20201bc806a4a454"

    # Backport fix for CMake 4
    patch do
      url "https://github.com/ldc-developers/ldc/commit/06b2e42a1b8436faae2b7976a1d41a635df116d5.patch?full_index=1"
      sha256 "80fd42d77217b16866e262008f283406bb597fee16cb6ade250d6d27f870ce5c"
    end

    # Backport fix for segmentation fault on macOS 15.4
    patch do
      url "https://github.com/ldc-developers/ldc/commit/60079c3b596053b1a70f9f2e0cf38a287089df56.patch?full_index=1"
      sha256 "44d281573a42e82ecdd48a6381fec4dde7aa6196f314e9eee7b1111ae6c54844"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256                               arm64_sequoia: "9384ccb16954cc0bd4cdc10cbff3b88f7c4198376adca1180d96f7f7ebd2ba43"
    sha256                               arm64_sonoma:  "97f6afa4dab17754196e9b29885721d61ce6244cdc2c627ac2d2e4a2ab9f62bc"
    sha256                               arm64_ventura: "284c606878e28375d5a6bd4dcba1ab090be8022d5fee5e974942c29a383a8e2b"
    sha256                               sonoma:        "46bb2adaf6f60942728c169eb3ab1c3951133ecdd6816c5ac3ba4aa32b7c7f02"
    sha256                               ventura:       "212beef9d9dd8f73794f2ca9a6c1786a1920d4f5c21f5800d2b17b09297e8417"
    sha256                               arm64_linux:   "eccf24bbebc2f4960b38f37612e16316b5cc1941d97930d27418eda01ae38240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d640a656f11e1f2e421a1d093a7d8bb183e0052aeca6101176b7b7c14adbed"
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
