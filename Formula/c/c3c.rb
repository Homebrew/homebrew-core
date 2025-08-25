class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "410267a3d771ac4b4d6bcc29be0faf30d4959c24b31f9d1bd00661656072dc2b"
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
    sha256 cellar: :any, arm64_sequoia: "76b4627f508edea70298a5e58202ee3a1fd66ba301f3f27885f4a1d2a5b6a647"
    sha256 cellar: :any, arm64_sonoma:  "b69907b9904a87266f75f0349d8d3fc3dcce8bcf3fcde23775df61ea5f931ba3"
    sha256 cellar: :any, arm64_ventura: "b38cb79e6f1e0979bf460127a7c9d1c98f51bc227d5dc0c4a2c850d141b49b01"
    sha256 cellar: :any, sonoma:        "e76cf7197b9f9de48288b15a2424c154133c5592d8b8ed328dc8b8640ba973b8"
    sha256 cellar: :any, ventura:       "5ef29f27699fdcf1933d37cac6c4166ae2b2bb9f350d951a2d58887bfc1a81aa"
    sha256               arm64_linux:   "a0424e7334c780f4eade36b16d794dc9453899bb9f54baeeadbddf00eebde517"
    sha256               x86_64_linux:  "2d484624c26dbcdc838dac9e68fc1fa591cfb197f409177263ac8219fb74dede"
  end

  # We are unable to rebuild bottles as url has a checksum mismatch and
  # upstream has not responded to https://github.com/c3lang/c3c/issues/2425
  # This can be removed if upstream confirms retag or in future release
  deprecate! date: "2025-08-25", because: :checksum_mismatch

  depends_on "cmake" => :build
  depends_on "lld@20"
  depends_on "llvm@20"

  uses_from_macos "curl"

  def install
    lld = Formula["lld@20"]
    llvm = Formula["llvm@20"]

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
