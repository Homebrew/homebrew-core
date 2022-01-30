class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.0.3.tar.gz"
  sha256 "488c12058b4c7c77bff94c6f919e40b2f12c304214e2e0d7d4833c21167837c0"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "b6d0872dc4e78f4d0fdfbc9ab76cf26dc5268e0ee29f15307c1d9cd0a2107494"
    sha256 arm64_big_sur:  "1dd8464a8856c146cddfec7f2077c6cf70a18967f091e136aaee5d9345544165"
    sha256 monterey:       "2120612b7735e17adbce710adef6be309383fac0d4a8fb35b1c3f09b8b14649d"
    sha256 big_sur:        "7689c4e59a576512baa9ba5e4ecee6d45217a1efba6b0333e935aec9c8044951"
    sha256 catalina:       "f426e485c2a9416c73e5a41e79c12ecaaede5baf62a4ae89906969c9347af108"
    sha256 x86_64_linux:   "e3fc5dbe542dea1d5c55bd2e8668b6f16be51f0a99dcd633f812e2bbbc1668ef"
  end

  depends_on "tbb"
  depends_on "xxhash"
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
      SYSTEM_XXHASH=1
    ]
    args << "STRIP=true" if OS.mac?
    system "make", *args, "install"

    inreplace buildpath.glob("test/*/*.sh") do |s|
      s.gsub!('mold="$(pwd)', "mold=\"#{bin}")
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
    return if OS.mac?

    system bin/"mold", "-run", ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
