class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.7.1.tar.gz"
  sha256 "fa2558664db79a1e20f09162578632fa856b3cde966fbcb23084c352b827dfa9"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "2cc6b8ae6a7c0e648848c2373d07cb67997e5101e4e57d8fc656dc353f46c841"
    sha256 cellar: :any,                 arm64_monterey: "68c9fd5f6b82627ac8d929f317a36ed00b6e7a4f1432bd3776ce966bfaf72ddf"
    sha256 cellar: :any,                 arm64_big_sur:  "1bfa53833bf1c63c0303d5573d424152af2987c9d777f88890143d38dbfa329c"
    sha256 cellar: :any,                 ventura:        "6790cf80be66f43a76bb2ba6b0ac1412a0a8be9818bc165030823c0ff0d80bb4"
    sha256 cellar: :any,                 monterey:       "afbacda1543ba674aa2136f95b9ae8c067746e7b84359507c0b587ff651e0204"
    sha256 cellar: :any,                 big_sur:        "6943c6d65bf51b164b9fd0de46bbe6904972c7f4fbe314ea71bf852cfd112f56"
    sha256 cellar: :any,                 catalina:       "32a875674d984b8a26ca348331a8f951608df0fa0924f0b9937a8e7faa5754f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4e5937fb04da867788249c3d4ebe51a2127e75b43d57afca493a12f215bc34"
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
    depends_on "openssl@3" # Uses CommonCrypto on macOS
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
