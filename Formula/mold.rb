class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.1.1.tar.gz"
  sha256 "47c5ddfe60beffc01da954191c819d78924e4d1eb96aeebfa24e1862cb3a33f9"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "7ef0d4b8bb277514a0d7d23cc360db1e9795aedb4506432fa417dfd34e16a1b9"
    sha256 arm64_big_sur:  "e89d234396f3c5bdc2bc5fa3546f47e91b753a0fda83f4d891049554ed9249b6"
    sha256 monterey:       "4234857a5bbe9e3a3d698ab75d14b6a4be78342497b3986d9ca4366412843e63"
    sha256 big_sur:        "aaf3cfa5c621e63bc7053d4ce392d1874fdefe3407a8b7805c5f19dcd75e080d"
    sha256 catalina:       "0ca759994e09f1562a4c67c0da8bad40c3d9cce759bc4d90f692d11e25f779d4"
    sha256 x86_64_linux:   "0e8624390f9d070681ef9c221863ac2d1ddeac431c24ab00f8bf861b3258850c"
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
