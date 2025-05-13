class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/refs/tags/v2.39.1.tar.gz"
  sha256 "231ea3643a14fe5b88478c97b68b31f7c975b57b247a81356ffd889d015b5cc1"
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
    sha256 cellar: :any,                 arm64_sequoia: "10c8ed21ca271d1ddf4733a41443a86856b3f61778a7cbc182632fdb2e0b05e4"
    sha256 cellar: :any,                 arm64_sonoma:  "5b88ab281021a1d4e65bc4e0dffc13f521c26bdd14751e2a0558758da81757ea"
    sha256 cellar: :any,                 arm64_ventura: "2fa9d9fc9d7f72c2836752dae3d206c7e36795ba6bc8ea572ece5a8718132d58"
    sha256 cellar: :any,                 sonoma:        "0abea8cf2462b287ee6380d24f26c1656bf7b77c8260cd483b66b21a30c5f0df"
    sha256 cellar: :any,                 ventura:       "bb7ddfaaf0813f53304ec0dd9e2048ca336f3811601259c05904223895907896"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe568aa6e726ed08a082f2fc79149d57aa8fcd200287e2cb2fbe83373a19e320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "570db503c502e9da521834d7dfe10eccd97efe7472dfd46f71494b87c1c2dbd2"
  end

  depends_on "cmake" => :build
  depends_on "blake3"
  depends_on "tbb"
  depends_on "zstd"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
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
    if OS.mac? && (DevelopmentTools.clang_build_version <= 1500)
      ENV.llvm_clang
      ENV.append "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/unwind -lunwind"
      # Work around failure mixing newer `llvm` headers with older Xcode's libc++:
      # Undefined symbols for architecture x86_64:
      #   "std::__1::__libcpp_verbose_abort(char const*, ...)", referenced from:
      #       std::__1::__throw_length_error[abi:nn200100](char const*) in lto.o
      #       std::__throw_bad_array_new_length[abi:nn200100]() in lto.o
      #       void std::__1::__throw_regex_error[abi:nn200100]<(std::__1::regex_constants::error_type)17>() in lto.o
      #       void std::__1::__throw_regex_error[abi:nn200100]<(std::__1::regex_constants::error_type)14>() in lto.o
      #       void std::__1::__throw_regex_error[abi:nn200100]<(std::__1::regex_constants::error_type)6>() in lto.o
      #       void std::__1::__throw_regex_error[abi:nn200100]<(std::__1::regex_constants::error_type)12>() in lto.o
      #       void std::__1::__throw_regex_error[abi:nn200100]<(std::__1::regex_constants::error_type)16>() in lto.o
      #       ...
      # When using Homebrew's superenv shims, we need to use HOMEBREW_LIBRARY_PATHS
      # rather than LDFLAGS for libc++ in order to correctly link to LLVM's libc++.
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", "#{Formula["llvm"].opt_lib}/c++"
    end

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
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac? && (DevelopmentTools.clang_build_version <= 1500)

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
