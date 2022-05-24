class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.2.1.tar.gz"
  sha256 "41868663ff18afee3fa35e5e3fdf3d9575eb2e4ff49967b8f42f479c61c1ec34"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "92f9195d7831a97e17b6b9c1e82b1b93b5294e1c14aeeb179c71dcd3bdd85805"
    sha256 arm64_big_sur:  "644571572b427e47dc20dc8783e715ace2f57f43628f3530587fa3ee796a24a9"
    sha256 monterey:       "234ab51333ca2569f322d039d77a2fc440ddb4d65c939de84ca9b933d427d3a5"
    sha256 big_sur:        "07454d53ebef64bb9f4b872e5940b6b0acc732b5d8bfc1201abab23d2d3d3e75"
    sha256 catalina:       "a0fcf049e0038568b4f6ce8607e8e724c9231b760b8a60631c834855bfaa9e4f"
    sha256 x86_64_linux:   "76a1d6dc558bf8f111d877df13d25300db7ce10f40c76ab1252ae00465462c8a"
  end

  depends_on "tbb"
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

    args = %W[
      PREFIX=#{prefix}
      LTO=1
      SYSTEM_MIMALLOC=1
      SYSTEM_TBB=1
    ]
    args << "STRIP=true" if OS.mac?
    system "make", *args, "install"

    inreplace buildpath.glob("test/*/*.sh") do |s|
      s.gsub!(/^mold=.+?((?:ld64\.)?mold)"?$/, "mold=\"#{bin}/\\1\"")
      s.gsub!(/"?\$mold"?-wrapper/, lib/"mold/mold-wrapper", false)
    end
    pkgshare.install "test"
  end

  test do
    # Avoid use of the `llvm_clang` shim.
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    (testpath/"test.c").write <<~EOS
      int main(void) { return 0; }
    EOS

    # GCC 12.1.0+ can also use `-fuse-ld=mold`
    linker_flag = case ENV.compiler
    when :clang then "-fuse-ld=mold"
    when /^gcc(-\d+)?$/ then "-B#{libexec}/mold"
    else raise "unexpected compiler"
    end

    system ENV.cc, linker_flag, "test.c"
    system "./a.out"
    # Lots of tests fail on ARM Big Sur for some reason.
    return if MacOS.version == :big_sur && Hardware::CPU.arm?

    if OS.mac?
      cp_r pkgshare/"test", testpath
      # Remove some failing tests.
      untested = %w[headerpad* pagezero-size basic response-file]
      testpath.glob("test/macho/{#{untested.join(",")}}.sh").map(&:unlink)
      (testpath/"test/macho").children.each { |t| system t }
    else
      system bin/"mold", "-run", ENV.cc, "test.c", "-o", "test"
      system "./test"
    end
  end
end
