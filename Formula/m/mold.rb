class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/refs/tags/v2.40.3.tar.gz"
  sha256 "308c10f480d355b9f9ef8bb414dfb5f4842bee87eb96b6a7666942f4036a0223"
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
    sha256 cellar: :any,                 arm64_sequoia: "60ed8ffe3b54a115ccae821bc90376fa8a11791b27d7d192fffdf29f38a4bdbb"
    sha256 cellar: :any,                 arm64_sonoma:  "3a9477ed2432ff91e2f58805735934f7d62616b4baa52803650110d023b17a26"
    sha256 cellar: :any,                 arm64_ventura: "5e7eb9d0e166b4dcda9f22765430ca299ca464e07405d6a337016503d491b1a9"
    sha256 cellar: :any,                 sonoma:        "f48b251add246c236baf7826e7b6bc2d9c5337de4a54b726e6bd92359cbe926c"
    sha256 cellar: :any,                 ventura:       "31e03bfa2f6a88139f2109a24889183d7eadcfd1e128f19ba9904d5fab7c6f6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fc0ed5912a5fe15b7d5a10ec5daa0b17f9b00c9a1c11002fdd3c027082ce2e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "540394a21f54ef7334a02fe9893a1bc357aa0002d8dcae3fe53df68c31f32c84"
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
    # Make sure <= Ventura does not have `CC=llvm_clang`.
    ENV.clang if OS.mac?

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
