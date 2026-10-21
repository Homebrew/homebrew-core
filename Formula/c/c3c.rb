class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://c3-lang.org"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "9fc60b5092ec63bb77ee5cb80df49a0929e38b2d56ce76d4211ccedb391ca709"
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
    sha256 cellar: :any, arm64_golden_gate: "1fa75fcb6af2a056b8a0c83c21ae005fcd211b963b5d56fd5412c20f8bfce9f9"
    sha256 cellar: :any, arm64_tahoe:       "972ebe4783db914403ef8a5b1514c824b7ba34517a64032f97addf1eaffb2c3c"
    sha256 cellar: :any, arm64_sequoia:     "8b3a849f56e9c17364befced0407a96a3c3011dece0ee877b6890d1961f797cb"
    sha256 cellar: :any, arm64_linux:       "51635b604ccfcedfe081324ce2467047053840988da76fcd19bdab074fd61a39"
    sha256 cellar: :any, x86_64_linux:      "401de8cf4231133a7fbf34fd29c84fc394642cee3f63e4ccec9abec45e053c2e"
  end

  depends_on "cmake" => :build
  depends_on "lld"
  depends_on "llvm"

  uses_from_macos "curl"

  deny_network_access!

  def install
    lld = Formula["lld"]
    llvm = Formula["llvm"]

    args = [
      "-DC3_LINK_DYNAMIC=ON",
      "-DC3_USE_MIMALLOC=OFF",
      "-DC3_USE_TB=OFF",
      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
      "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm",
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
    (testpath/"test.c3").write <<~C3
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    C3
    system bin/"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}/test")
  end
end
