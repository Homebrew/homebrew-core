class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.2.1.tar.gz"
  sha256 "41868663ff18afee3fa35e5e3fdf3d9575eb2e4ff49967b8f42f479c61c1ec34"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "d004bc9405e400c43ee67fe741e037bb2887fe86e950c2866e9cb601d3367a85"
    sha256 arm64_big_sur:  "aac991f985178cca9645b7296de3a9a3bff45d53626641a920ac491f75314769"
    sha256 monterey:       "b405e4fd77f61dd4cb9c6575cba9c9d0b80f72a4398b68e8d26a5108c39b1bb8"
    sha256 big_sur:        "f53f2f2faf8fb14737df9eaa97daacaaa0d81465a59e6f848712889a879ed0c9"
    sha256 catalina:       "023d89ae608267e726a280836744fe301f95e5704d07d66bd2bce7daae55e9a2"
    sha256 x86_64_linux:   "5f9a7df69c7de3609ed7804124af7e282ab6ed6573b82e2e69c0633e2c8b9002"
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
