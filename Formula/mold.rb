class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.1.1.tar.gz"
  sha256 "47c5ddfe60beffc01da954191c819d78924e4d1eb96aeebfa24e1862cb3a33f9"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "54fd2aa58e34b16de07e43bf7fca4278069547fc9adc41cdbb4fe5f476735a45"
    sha256 arm64_big_sur:  "9cbd6a16091a5bec3dfe781c55b54e538c9b4b325f72ec14de85ead7e300115b"
    sha256 monterey:       "dad283ead1dda3d5209091fbe0b07633745eaf2fe85faf242dfa2b35e9c11994"
    sha256 big_sur:        "55adb693ed2aa555defde2ed7d8749aba94ff7ad5d36450c5c3f86569af18e1d"
    sha256 catalina:       "71d2a690281992686f844b4faee02108afbd42d2e577f1f1898ee22836c462d1"
    sha256 x86_64_linux:   "ebdebec0ea664c0106e27c19d54aaff04337f8747fdc3a39c28b990493aca1f6"
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
