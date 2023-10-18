class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "78ddddaaa004e50f8d92a13d8e792a46a1b37745fab48d39ad16aeb5a776e7c6"
  license "MIT"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d22ad50c9e8ca1f600011bcd5c7201ebe3a53195638ef061f44b15e8f0da86d1"
    sha256 cellar: :any,                 arm64_ventura:  "92f03596fbc5ea1eed45fef8f9d9644256282e8b739f1d97ae8cddb789a169e5"
    sha256 cellar: :any,                 arm64_monterey: "8a4c9674faf17ceb438a29ec59d9e573e34127a76e7474ecad40abfebdd90c4e"
    sha256 cellar: :any,                 arm64_big_sur:  "3be891353bf93aa24e1e858f246369928b4fe1c30e80cfc96e7c5768790aa9be"
    sha256 cellar: :any,                 sonoma:         "a1f050e7cf3dc4e06f843e7da3c866e8ab9e04e648e6f058b81e351c1e8ed945"
    sha256 cellar: :any,                 ventura:        "5c633df79e79da593256be819786d9155c08f09828a0e99a98ba38140005bb98"
    sha256 cellar: :any,                 monterey:       "79b8430dfe2424250f81e6a59ba0166b870810e41b34e02d65d7cd9ff1281ad7"
    sha256 cellar: :any,                 big_sur:        "b5f5887f9c403ff6490693e4d949b02f7c9516324de892250330cacc4d367d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f84b38a76ba7de114ed14d90e96f2685deb65da55d81119d868375920b4a7344"
  end

  depends_on "cmake" => :build
  depends_on "blake3"
  depends_on "tbb"
  depends_on "zstd"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "mimalloc"
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
    %w[blake3 mimalloc tbb zlib zstd].each { |dir| (buildpath/"third-party"/dir).rmtree }
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

    extra_flags = %w[-fPIE -pie]
    extra_flags += %w[--target=x86_64-unknown-linux-gnu -nostdlib] unless OS.linux?

    system ENV.cc, linker_flag, *extra_flags, "test.c"
    if OS.linux?
      system "./a.out"
    else
      assert_match "ELF 64-bit LSB pie executable, x86-64", shell_output("file a.out")
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
