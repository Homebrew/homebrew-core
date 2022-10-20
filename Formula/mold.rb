class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.6.0.tar.gz"
  sha256 "59cd3ea1a2a5fb50d0d97faddd8bff4c7e71054a576c00a87b17f56ecbd88729"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "076338cdf41f1c403516dc7f9e6acd1c940893b388c86b45ae1c834c6760e820"
    sha256 cellar: :any,                 arm64_big_sur:  "bb483a8a578217eaacd1af58268312e66617a89a0af2592217fea0dec1a4fde6"
    sha256 cellar: :any,                 monterey:       "150c90061b5071315d8e24df6a57a2640662e096815225a89f170b16aea41ef4"
    sha256 cellar: :any,                 big_sur:        "94ad4e9c77451fe06844d73686e3f5773d6c47db092ef0f22e4af3fa58a618d4"
    sha256 cellar: :any,                 catalina:       "9596cca4cc75cc2e53bf3440d06e76a48426bbdc98eef6a0796e182369d4fdb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32fa1a5949e8b986715b0e32127e546f92cd7583de3384a695d760bc1f700abe"
  end

  depends_on "cmake" => :build
  depends_on "tbb"
  depends_on "zstd"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "mimalloc"
    depends_on "openssl@1.1" # Uses CommonCrypto on macOS
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    # Undefine the `LIBDIR` macro to avoid embedding it in the binary.
    # This helps make the bottle relocatable.
    ENV.append_to_cflags "-ULIBDIR"
    # Ensure we're using Homebrew-provided versions of these dependencies.
    %w[mimalloc tbb zlib zstd].map { |dir| (buildpath/"third-party"/dir).rmtree }
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
      # Delete failing test. Reported upstream at
      # https://github.com/rui314/mold/issues/735
      if (MacOS.version == :monterey) && Hardware::CPU.arm?
        untested = %w[libunwind objc-selector]
        testpath.glob("test/macho/{#{untested.join(",")}}.sh").map(&:unlink)
      end
      testpath.glob("test/macho/*.sh").each { |t| system t }
    else
      system bin/"mold", "-run", ENV.cc, "test.c", "-o", "test"
      system "./test"
    end
  end
end
