class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.0.3.tar.gz"
  sha256 "488c12058b4c7c77bff94c6f919e40b2f12c304214e2e0d7d4833c21167837c0"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "eb6727a0176d76f1c211dfabee365c0c8a0d4d8b7b234a7c7808572823cb347b"
    sha256 arm64_big_sur:  "290ea04b26902231c07ce12e90bfe9b1fe45df599258b55b14804c370d7aec57"
    sha256 monterey:       "24b64743c5314863f47b47ad6dd911dd1bb61010a32cdd4748273f6c061b8bbd"
    sha256 big_sur:        "9b073fc78fd7f91927b1cc9e6ef448e403917a791cf0e5b6e86c31d3ba4221df"
    sha256 catalina:       "87d413911114a89529a48f3dfb16ce1309ad148d423ebad6c28b72d10d686293"
    sha256 x86_64_linux:   "ee4c785aa85d2142b62591b7d8ea239894751e11ca0f3ed30e47fc5615535bc4"
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
