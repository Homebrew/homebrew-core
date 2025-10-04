class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "607f2147da4f4479887698699fc97134d2172102005ea29fa37ab6f2659c04b4"
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
    sha256 cellar: :any,                 arm64_tahoe:   "80a5e0acb0d811b2188d337a41874037b8afe34b70eefbd84836f5168393c144"
    sha256 cellar: :any,                 arm64_sequoia: "759cb0f4fdefefc43bebf4d672fd72efbe37e3f661cc2572f1f9593bb6e4128e"
    sha256 cellar: :any,                 arm64_sonoma:  "ded734b13f9696971c7df2d035d2f6b6ebd615da78c53531b4f1254a53056571"
    sha256 cellar: :any,                 sonoma:        "2ee8d486fb7bc0948b498a6b098889f8e11e65099c111eda3927b56591eef18f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d18321255d67ee3897ddbe0c2de3e19231b91306077d2e7d06d108eacb719aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45f6cc6d7129fea4b0b3c1446e59ef0f2d6a934703cf5ca8baddc1052e49b11c"
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
