class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "54bc00eb3ed69d89af80362ef3ee17d30dc7186eccd8b2f4fb9afbf616136115"
  license "LGPL-3.0-only"
  head "https://github.com/c3lang/c3c.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4caa65b939edc037622f75659a1326dec13691ea5b02778d63e090bd2ca8cb74"
    sha256 cellar: :any,                 arm64_sequoia: "6ef52612f7e4dc257eb2cd5fe6b1454526ccdacaa06adb79b4bff06aef60fa6c"
    sha256 cellar: :any,                 arm64_sonoma:  "711a9f68fa713ace15d502e51da183e599e30df50bdfbc87645b8d1a98dab1a1"
    sha256 cellar: :any,                 sonoma:        "584b6aea037f54d68e1f26ce9c160de885be59243c36fcd897943522970cbea0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "081ae9dda67d0ff6a585974ecbdb27d76f28466684a891275253c92acb6ba3f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f29f3cffb1f98e1e0b8cb9c4009a3dbb7c99b6e8f240e46513f287db8c43b5"
  end

  depends_on "cmake" => :build
  depends_on "lld@21"
  depends_on "llvm@21"

  uses_from_macos "curl"

  def install
    lld = Formula["lld@21"]
    llvm = Formula["llvm@21"]

    args = [
      "-DC3_LINK_DYNAMIC=ON",
      "-DC3_USE_MIMALLOC=OFF",
      "-DC3_USE_TB=OFF",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
      "-DLLVM=#{llvm.opt_lib/shared_library("libLLVM")}",
      "-DLLD_COFF=#{lld.opt_lib/shared_library("liblldCOFF")}",
      "-DLLD_COMMON=#{lld.opt_lib/shared_library("liblldCommon")}",
      "-DLLD_ELF=#{lld.opt_lib/shared_library("liblldELF")}",
      "-DLLD_MACHO=#{lld.opt_lib/shared_library("liblldMachO")}",
      "-DLLD_MINGW=#{lld.opt_lib/shared_library("liblldMinGW")}",
      "-DLLD_WASM=#{lld.opt_lib/shared_library("liblldWasm")}",
    ]
    args << "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # The build copies LLVM runtime libraries into its `bin` directory.
    # Let's replace those copies with a symlink instead.
    libexec.install bin.children
    bin.install_symlink libexec.children.select { |child| child.file? && child.executable? }
    rm_r libexec/"c3c_rt"
    libexec.install_symlink llvm.opt_lib/"clang"/llvm.version.major/"lib/darwin" => "c3c_rt"
  end

  test do
    (testpath/"test.c3").write <<~EOS
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    EOS
    system bin/"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}/test")
  end
end
