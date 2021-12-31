class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.0.1.tar.gz"
  sha256 "b0d54602d1229c26583ee8a0132e53463c4d755f9dbc456475f388fd8a1aa3e4"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "34632011c7a7ce08462a21076cf08692f38ca87a8d908de5df6c26370415a52e"
    sha256 arm64_big_sur:  "95b8feed7e3eb148ee569fe77f3fba0febd66922fc1ec06b5b6ac3681e47fba1"
    sha256 monterey:       "cf6cfb16a9c7fbda0febf286791f11d707485ddde06b8895bbb9be9313e8aceb"
    sha256 big_sur:        "378385004a302a55daab4d6b0736d8ec494c53840fd015d8cb2e1ecf43aa0cf1"
    sha256 catalina:       "81ea214352cb75b194e154dc3b7503bb8dc3e527321bd5cf79405cb7831ade1d"
    sha256 x86_64_linux:   "c31fc419f53fe542d4dd32ba60c9bbc42728e409cd815d6ff88010b7090acb7f"
  end

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
