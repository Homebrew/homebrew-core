class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "99318eced81b09a77e4c657011076cc8ec3d4b6867bd324b8677974545bc4d6f"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41c470ed38ccb4a7693582514388d09394f8a1aa82a38facaf8f32606a8a346a"
    sha256 cellar: :any,                 arm64_monterey: "daefd55abeb1761a76aa964e202d2b5775bd93c1c48eaf044b5693b2e18a3f77"
    sha256 cellar: :any,                 arm64_big_sur:  "c12a49ee4a1fa780959c08960c211d7df05b49881e2dbb32f119de528f1e9ee1"
    sha256 cellar: :any,                 ventura:        "d724d5b837a060f95f10d4fdd2888b84e8fe4f18a31e99d83463bc268196553a"
    sha256 cellar: :any,                 monterey:       "b305856bb491e3db7c3d185a967840e10d602b0c6c3bedfcfdd47800919dfeac"
    sha256 cellar: :any,                 big_sur:        "a819a049f75bc106e6ba4bba4712b4a86718397bd18d15e2bf0b96d9305f8c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf0da43e2724210e3850bdbdb0dd4f686af84c068afb0d9db5a37424cdf37248"
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
    inreplace "common/config.h.in", "@CMAKE_INSTALL_FULL_LIBDIR@", ""
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

    pkgshare.install "test"
  end

  def caveats
    <<~EOS
      Support for Mach-O targets has been removed.
      See https://github.com/bluewhalesystems/sold for macOS/iOS support.
    EOS
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

    extra_flags = []
    extra_flags += %w[--target=x86_64-unknown-linux-gnu -nostdlib] unless OS.linux?

    system ENV.cc, linker_flag, *extra_flags, "test.c"
    if OS.linux?
      system "./a.out"
    else
      assert_match "ELF 64-bit LSB executable, x86-64", shell_output("file a.out")
    end

    return unless OS.linux?

    cp_r pkgshare/"test", testpath

    # Remove non-native tests.
    arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch.to_s
    testpath.glob("test/elf/*.sh")
            .reject { |f| f.basename(".sh").to_s.match?(/^(#{arch}_)?[^_]+$/) }
            .each(&:unlink)

    inreplace testpath.glob("test/elf/*.sh") do |s|
      s.gsub!(%r{(\./|`pwd`/)?mold-wrapper}, lib/"mold/mold-wrapper", false)
      s.gsub!(%r{(\.|`pwd`)/mold}, bin/"mold", false)
      s.gsub!(/-B(\.|`pwd`)/, "-B#{libexec}/mold", false)
    end

    # The `inreplace` rules above do not work well on this test. To avoid adding
    # too much complexity to the regex rules, it is manually tested below
    # instead.
    (testpath/"test/elf/mold-wrapper2.sh").unlink
    assert_match "mold-wrapper.so",
      shell_output("#{bin}/mold -run bash -c 'echo $LD_PRELOAD'")

    # Run the remaining tests.
    testpath.glob("test/elf/*.sh").each { |t| system "bash", t }
  end
end
