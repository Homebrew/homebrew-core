class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/refs/tags/v2.34.1.tar.gz"
  sha256 "a8cf638045b4a4b2697d0bcc77fd96eae93d54d57ad3021bf03b0333a727a59d"
  license "MIT"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0aa7ac1193cecac1c78b3545953d8bc7009faf324c25c1e02cc2d26598a7154d"
    sha256 cellar: :any,                 arm64_sonoma:  "954b9c4ef7fbfe0a56fcb2cd39e50fc590335edbcb58d7a305a2b6d8ea84667f"
    sha256 cellar: :any,                 arm64_ventura: "a8f194f72d412348873617439dce5050465abc1c8c35f9602ae777a48a2a5eac"
    sha256 cellar: :any,                 sonoma:        "213b7a4bfd81052de322188a7630e564f5e5361863a0c91acf9f1625c40c044a"
    sha256 cellar: :any,                 ventura:       "ae19f47d88d50bd5b237ad47bb67cb7389c9f27106b39469dda5f66503c9fe52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2477939c35c0a9d9effd4644334a2f7444a6a0e0eb4d468b22e49fdb32ffeaa"
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
    inreplace "lib/config.h.in", "@CMAKE_INSTALL_FULL_LIBDIR@", ""
    # Ensure we're using Homebrew-provided versions of these dependencies.
    %w[blake3 mimalloc tbb zlib zstd].each { |dir| rm_r(buildpath/"third-party"/dir) }
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
    arch = Hardware::CPU.arch.to_s
    arch = "aarch64" if arch == "arm64"
    testpath.glob("test/arch-*.sh")
            .reject { |f| f.basename(".sh").to_s.match?(/^arch-#{arch}-/) }
            .each(&:unlink)

    inreplace testpath.glob("test/*.sh") do |s|
      s.gsub!(%r{(\./|`pwd`/)?mold-wrapper}, lib/"mold/mold-wrapper", audit_result: false)
      s.gsub!(%r{(\.|`pwd`)/mold}, bin/"mold", audit_result: false)
      s.gsub!(/-B(\.|`pwd`)/, "-B#{libexec}/mold", audit_result: false)
    end

    # The `inreplace` rules above do not work well on this test. To avoid adding
    # too much complexity to the regex rules, it is manually tested below
    # instead.
    (testpath/"test/mold-wrapper2.sh").unlink
    assert_match "mold-wrapper.so",
      shell_output("#{bin}/mold -run bash -c 'echo $LD_PRELOAD'")

    # Run the remaining tests.
    testpath.glob("test/*.sh").each { |t| system "bash", t }
  end
end
