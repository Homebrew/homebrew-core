class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.0.0.tar.gz"
  sha256 "d7cf170b57a3767d944c80c7468215fa9f8fa176f94f411a5b62b3f56cf07400"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  depends_on "tbb"
  depends_on "xxhash"
  uses_from_macos "zlib"

  on_macos do
    # mold can only link ELF executables (for now)
    # https://github.com/rui314/mold/issues/189
    depends_on "x86_64-elf-gcc" => :test
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
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main(void) { return 0; }
    EOS

    ENV["CC"] = "x86_64-elf-gcc" if OS.mac?

    system ENV.cc, "-c", "test.c"
    system bin/"mold", "test.o"
    assert_predicate testpath/"a.out", :exist?
    return if OS.mac?

    system bin/"mold", "-run", ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
