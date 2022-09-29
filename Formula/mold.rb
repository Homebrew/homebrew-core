class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.5.1.tar.gz"
  sha256 "ec94aa74758f1bc199a732af95c6304ec98292b87f2f4548ce8436a7c5b054a1"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "ba3f4bf4429811c8f348f548b624d099479d2806ee0bf9ad8e2d5c79be584aa3"
    sha256 cellar: :any, arm64_big_sur:  "e149035a9472ee5f4f4549cf8a5c4e42155d49809f61d417a8c924e225532d4f"
    sha256 cellar: :any, monterey:       "03ce1df456b6528301b2aa269ca92fc20c66323329c9f9656386b9cb90cc5a89"
    sha256 cellar: :any, big_sur:        "aed925c6585f646b00c4d71e26c87ca090a76a13ecebfaa67b63f8ea0d2338ba"
    sha256 cellar: :any, catalina:       "33791aeeb8ba68b3eb9cd71eeb2d7941b9e7cff9a0d304e9543661bda84c70f5"
    sha256               x86_64_linux:   "1d8a402ea0bb036bfadd194c9e8c2aed7088940d300c3b05c856d0ece64f56c8"
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
