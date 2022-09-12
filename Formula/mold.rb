class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.4.2.tar.gz"
  sha256 "47e6c48d20f49e5b47dfb8197dd9ffcb11a8833d614f7a03bd29741c658a69cd"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d9ca2c1f6af2e4f743d4288720761a823281d61f275432d52e8cca1dcc5cb07b"
    sha256 cellar: :any,                 arm64_big_sur:  "8724e3ac84bf9e0b622a3288ca0ef0e2fc908f69652c76739bbbfe3265272cf1"
    sha256 cellar: :any,                 monterey:       "496404b2907ec2ebf7d3b9d3240835701ba08e9f883841941e776686335bc7b9"
    sha256 cellar: :any,                 big_sur:        "6db751d4f6fa051067ff636047beb77082d070b2e757009d572fcb616fb4f4a3"
    sha256 cellar: :any,                 catalina:       "2422b73a95ec0b419cf0cf266fd5f0fbf2bd484a02c59440b92a2f42b8a29064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e367801bde744244609a4100c43855b22f0f358b5005852ec286fbd2d911b87"
  end

  depends_on "cmake" => :build
  depends_on "tbb"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "mimalloc"
    depends_on "openssl@1.1" # Uses CommonCrypto on macOS
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  # Requires C++20
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    # Ensure we're using Homebrew-provided versions of these dependencies.
    %w[mimalloc tbb zlib].map { |dir| (buildpath/"third-party"/dir).rmtree }
    args = %w[
      -DMOLD_LTO=ON
      -DMOLD_USE_MIMALLOC=ON
      -DMOLD_USE_SYSTEM_MIMALLOC=ON
      -DMOLD_USE_SYSTEM_TBB=ON
      -DCMAKE_SKIP_INSTALL_RULES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace buildpath.glob("test/macho/*.sh"), "./ld64", bin/"ld64.mold", false
    inreplace buildpath.glob("test/elf/*.sh") do |s|
      s.gsub!(%r{(`pwd`/)?mold-wrapper}, lib/"mold/mold-wrapper", false)
      s.gsub!(%r{(\.|`pwd`)/mold}, bin/"mold", false)
      s.gsub!(/-B[^\s]+/, "-B#{libexec}/mold", false)
    end
    pkgshare.install "test"
  end

  test do
    # Avoid use of the `llvm_clang` shim.
    if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
      ENV.clang
      ENV.prepend_path "PATH", Formula["llvm"].opt_bin
    end

    (testpath/"test.c").write <<~EOS
      int main(void) { return 0; }
    EOS

    linker_flag = case ENV.compiler
    when /^gcc(-(\d|10|11))?$/ then "-B#{libexec}/mold"
    when :clang, /^gcc-\d{2,}$/ then "-fuse-ld=mold"
    else odie "unexpected compiler"
    end

    system ENV.cc, linker_flag, "test.c"
    system "./a.out"
    # Tests use `--ld-path`, which is not supported on old versions of Apple Clang.
    return if OS.mac? && MacOS.version < :big_sur

    if OS.mac?
      cp_r pkgshare/"test", testpath
      testpath.glob("test/macho/*.sh").each { |t| system t }
    else
      system bin/"mold", "-run", ENV.cc, "test.c", "-o", "test"
      system "./test"
    end
  end
end
