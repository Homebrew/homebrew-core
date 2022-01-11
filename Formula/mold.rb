class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.0.1.tar.gz"
  sha256 "b0d54602d1229c26583ee8a0132e53463c4d755f9dbc456475f388fd8a1aa3e4"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "3781e61f8fb03d6672d6e1d8b846abaefedf49602db4663338df817ae6cc5c2d"
    sha256 arm64_big_sur:  "e5dada695a6c6e59b9ae334ba2dda63fda1144e7f507e1601bbcca82d0c2f087"
    sha256 monterey:       "332282d118bad7686376da63c25465c31c1056002358fdc400655966e06f3b99"
    sha256 big_sur:        "03c3f38e45e0ae85263c693598a08623981a13764401a91f2f9451fc53fef18d"
    sha256 catalina:       "8f1200a17e13e0019456671a639dcb6dd5af654c4e57598bdfd072d5a72267cd"
    sha256 x86_64_linux:   "44acff1b888add128a9f9ec09ab35289518868194bcaad3d508dd354d4207fd3"
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
