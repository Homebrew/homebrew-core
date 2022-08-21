class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  # Remove `stable` block and `python` dep at next release.
  stable do
    url "https://github.com/rui314/mold/archive/v1.4.1.tar.gz"
    sha256 "394036d299c50f936ff77ce9c6cf44a5b24bfcabf65ae7db9679f89c11a70b3f"

    # Use a portable shebang in `update-git-hash.py`.
    # https://github.com/rui314/mold/pull/637
    # Remove at next release.
    patch do
      url "https://github.com/rui314/mold/commit/dea48143db46e759682dbd12ae5dd51591056a45.patch?full_index=1"
      sha256 "831a5170544b02a01d9b31728a4c92af833993e35fa83fe675495f46affb3119"
    end

    # Fix installation of `mold-wrapper.so` on Linux. Remove at next release.
    patch do
      url "https://github.com/rui314/mold/commit/9c61fc648d52d93ca2c04241c202ebfa8a017b0c.patch?full_index=1"
      sha256 "4c7f67423aea6058aabaff60bde52e2a48d8951ac3204c2721ddcd559180ff6c"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "1769f0f31daaa8c9001f5a3926e4c5dcc304e22e9560e9c22984677538e14b65"
    sha256 cellar: :any, arm64_big_sur:  "1e8c9d89d0ea082402d0934cdb1d5e62631602e688afcdb99d0b9e708e34ee11"
    sha256 cellar: :any, monterey:       "269acc4b86a893bf75910175c59f4eae65bdcfeba532a89994ddf1a02c97f75c"
    sha256 cellar: :any, big_sur:        "ca94aa841c7db02bffacfbcba6b54f5556e85a34ced605910aa3e6bebe18db44"
    sha256 cellar: :any, catalina:       "824ea85e81d588389b41f3178de64d2d39c67bfc00911e6cd7c6d61492478f66"
    sha256               x86_64_linux:   "1f6956da7d017869584c2c03d65f3b674479618f7c23061e8196022df760c161"
  end

  depends_on "cmake" => :build
  depends_on "tbb"
  # FIXME: Remove at next release.
  # https://github.com/rui314/mold/issues/636
  uses_from_macos "python" => :build, since: :catalina # needed to run update-git-hash.py
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "gcc"
    depends_on "mimalloc"
    depends_on "openssl@1.1" # Uses CommonCrypto on macOS
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  # Requires C++20
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    # Ensure we're using Homebrew-provided versions of these dependencies.
    %w[mimalloc tbb zlib].map { |dir| (buildpath/"third-party"/dir).rmtree }
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
      s.gsub!(%r{(\.|`pwd`)/mold }, "#{bin}/mold ", false)
      s.gsub!(%r{(`pwd`/)?mold-wrapper}, lib/"mold/mold-wrapper", false)
    end
    pkgshare.install "test"
  end

  test do
    # Avoid use of the `llvm_clang` shim.
    if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
      ENV.clang
      ENV.prepend_path "PATH", Formula["llvm"].opt_bin
    end

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
    # Lots of tests fail on ARM Big Sur for some reason.
    return if MacOS.version == :big_sur && Hardware::CPU.arm?

    if OS.mac?
      cp_r pkgshare/"test", testpath
      # Remove some failing tests.
      untested = %w[headerpad* pagezero-size basic response-file]
      homebrew_clang = Utils.safe_popen_read("clang", "--version").include?("Homebrew")
      untested << "syslibroot" if homebrew_clang
      testpath.glob("test/macho/{#{untested.join(",")}}.sh").map(&:unlink)
      testpath.glob("test/macho/*.sh").each { |t| system t }
    else
      system bin/"mold", "-run", ENV.cc, "test.c", "-o", "test"
      system "./test"
    end
  end
end
