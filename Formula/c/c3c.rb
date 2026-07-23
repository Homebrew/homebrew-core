class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://c3-lang.org"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "154a7c464081db4ea66c2ba1885f170794254aafb5a492dbbdcad1f23acadcf5"
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
    sha256 cellar: :any, arm64_tahoe:   "237053d88dff28b26f11171dff5d096fd48544ad362321578b56e4a03eca0096"
    sha256 cellar: :any, arm64_sequoia: "67da7e2b9a23571eef16ee3c37670859dd40d38164b6ee06b2c9b65a0e4c1390"
    sha256 cellar: :any, arm64_sonoma:  "e41d4ef4bb6f512c9663571dffc209b30d72548c59b93e8a1741ae360443397b"
    sha256 cellar: :any, sonoma:        "df7504ce4d2dbb25a99af5c434c10988dbc29b99dc0338b52c0f1325b9fb2979"
    sha256 cellar: :any, arm64_linux:   "13e301e10f8f5f8ee5328513ce575b845c325775859d53b784e6c028048e3e6c"
    sha256 cellar: :any, x86_64_linux:  "8abd58fcd4547056c760d6491b4521e481aa68daffebfa4ccfe248f181613092"
  end

  depends_on "cmake" => :build
  depends_on "lld"
  depends_on "llvm"

  uses_from_macos "curl"

  def install
    lld = Formula["lld"]
    llvm = Formula["llvm"]

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
