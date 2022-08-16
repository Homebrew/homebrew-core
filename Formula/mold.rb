class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.4.0.tar.gz"
  sha256 "c255af236e629a3afb0cd89185a3a944741aa55bfbe966eb175af1c7b6097c0b"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "52f6d7fd4a56c26c0e314c6d741637df47b8482e55cd6eaf3b7ccf872910639a"
    sha256 cellar: :any, arm64_big_sur:  "b4824beee601471be2fcfbcfe31d227442dd893bf3c9b369fb401285359d3716"
    sha256 cellar: :any, monterey:       "7c264bb01f8c5c72ff3d023cb233c0dc3eb47de3b34b0d3988808585f874af71"
    sha256 cellar: :any, big_sur:        "59959cb0eb39961697d920cbc3856bcc5b3aeb265391f577aedde7542c4cc233"
    sha256 cellar: :any, catalina:       "a6ed68490ac4992896d1e9c146d7bf751e9b95680feb773c837392984f0dca84"
    sha256               x86_64_linux:   "25d98acdaf7133398a274037d6bae48b1624f357f7a05b1893acd8c868a5c747"
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
      (testpath/"test/macho").children.each { |t| system t }
    else
      system bin/"mold", "-run", ENV.cc, "test.c", "-o", "test"
      system "./test"
    end
  end
end
