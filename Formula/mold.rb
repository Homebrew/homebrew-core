class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.7.1.tar.gz"
  sha256 "fa2558664db79a1e20f09162578632fa856b3cde966fbcb23084c352b827dfa9"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "99ea7e8eec146f8b7eb11c86e83721a562d8519d7f403e29bfb3c053f5cea917"
    sha256 cellar: :any,                 arm64_monterey: "4ae463200d72d37e33ed1dad9428bd7cdb6a0d232b7c7181ff7e49be978f44f9"
    sha256 cellar: :any,                 arm64_big_sur:  "0801c996eb684e9f0d5588f8cfa31626f98c902a58b6f21fc2abdceff646795e"
    sha256 cellar: :any,                 ventura:        "1e8349b6fef28db2e311893757b7a2ef4f9699a22309b06460c19f84730e29d8"
    sha256 cellar: :any,                 monterey:       "f4a60f330bb6517877dbf207de391f9789d60d402a9f8228505507bd8da534c3"
    sha256 cellar: :any,                 big_sur:        "2d60b504d6416ef723c6609a427c4117cd9ea047c5f907d28cfc8421a1c1ff80"
    sha256 cellar: :any,                 catalina:       "ddf080287e5b51f3abba16ce22d371b9c3ab8f112910725ccd6438bb6b4fdc71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fddf615ee4a6c2b00ea21e12c7a9f47d17db6c3a96dcc56750e1ebd55b5c45a8"
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

    # Avoid embedding libdir in the binary.
    # This helps make the bottle relocatable.
    inreplace "config.h.in", "@CMAKE_INSTALL_FULL_LIBDIR@", ""
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
      s.gsub!(%r{(\./|`pwd`/)?mold-wrapper}, lib/"mold/mold-wrapper", false)
      s.gsub!(%r{(\.|`pwd`)/mold}, bin/"mold", false)
      s.gsub!(/-B(\.|`pwd`)/, "-B#{libexec}/mold", false)
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

    cp_r pkgshare/"test", testpath
    if OS.mac?
      # Delete failing test. Reported upstream at
      # https://github.com/rui314/mold/issues/735
      if (MacOS.version >= :monterey) && Hardware::CPU.arm?
        untested = %w[libunwind objc-selector]
        testpath.glob("test/macho/{#{untested.join(",")}}.sh").map(&:unlink)
      end
      testpath.glob("test/macho/*.sh").each { |t| system t }
    else
      # The substitution rules in the install method do not work well on this
      # test. To avoid adding too much complexity to the regex rules, it is
      # manually tested below instead.
      (testpath/"test/elf/mold-wrapper2.sh").unlink
      assert_match "mold-wrapper.so",
        shell_output("#{bin}/mold -run bash -c 'echo $LD_PRELOAD'")
      # This test file does not have permission to execute, so we skip it.
      # Remove on next release as this is already fixed upstream.
      (testpath/"test/elf/section-order.sh").unlink
      # Run the remaining tests.
      testpath.glob("test/elf/*.sh").each { |t| system t }
    end
  end
end
