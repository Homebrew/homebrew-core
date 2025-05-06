class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "32a0917894b9bc9317ba5d6bdbcad8401513bcdfbbbcfc9de55423c46db8511c"
  license "MIT"
  head "https://github.com/rui314/mold.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "10ab852e3dc9f47589bb4e8f734ee20c382e1e8d276d7c55134844ca175d6d8a"
    sha256 cellar: :any,                 arm64_sonoma:  "e752be3fa9634ef2c38c936cf08cfa60a5686b25cc756bccd77fe246b4063e20"
    sha256 cellar: :any,                 arm64_ventura: "34fd16594cbcb9eb9cc1a03ae42be22faddb4c80373b347da61de9343c1c5d5e"
    sha256 cellar: :any,                 sonoma:        "114dd89def4ce67941c74d0ba22c20198d10e50075d7d2d8fb1b170689e1cac8"
    sha256 cellar: :any,                 ventura:       "5dfe6777c1831f2918f18c524db64dc0e2c942a4c48ee83a81c55e1692b85b74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73ab21dcf4e8045013755deb6dc6ddb9ef2b95a4ed1b47bb1d4aab67d6dd729f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3f6639e506ff3fca0a926fd47ce801a51bb6c5a6c12690500d83b5e9c002d0c"
  end

  depends_on "cmake" => :build
  depends_on "blake3"
  depends_on "tbb"
  depends_on "zstd"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "mimalloc"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1500)

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
    EOS
  end

  test do
    (testpath/"test.c").write <<~C
      int main(void) { return 0; }
    C

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
