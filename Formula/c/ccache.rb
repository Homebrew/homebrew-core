class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.14.2/ccache-4.14.2.tar.xz"
  sha256 "0feb2707d9cb48885abb950e5d629e85f57fa79a2439cbbdfa681d6c3dc5f0dc"
  license "GPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/ccache/ccache.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "8a3df0218130b3a456cc55e8d795b95c150b5c4a3ab25dc5bf234445ce3ea12b"
    sha256 arm64_tahoe:       "3ac7f3e3e0373e379d33c39483af4b9a8cf7ad22c2807992198fd7d9f0bde5ec"
    sha256 arm64_sequoia:     "6c45bb9f0429eb114b09e8ea5d3225cb895d90db31da3dc55b5e4d18b48bc54c"
    sha256 arm64_linux:       "37719daf3f2ebb1a9ca05b3525f5f4fb502632ba29d3e3a4389990c93e877842"
    sha256 x86_64_linux:      "20d1d5d4127c06da376c7c8c2e83617a7f7f6f2344c5af6b1c3e0183c2125ae5"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "cpp-httplib" => :build
  depends_on "doctest" => :build
  depends_on "pkgconf" => :build
  depends_on "span-lite" => :build
  depends_on "tl-expected" => :build

  depends_on "blake3"
  depends_on "fmt"
  depends_on "hiredis"
  depends_on "openssl@4"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "elfutils" => :build
    depends_on "zlib-ng-compat"
  end

  # Workaround to allow running tests with Xcode 27 / LLVM 23 after
  # https://github.com/swiftlang/llvm-project/commit/1e4f2519930f8756f49865096636954a33334217
  # https://github.com/llvm/llvm-project/commit/aba18cf1cc65d5333940c4299251d986f66dee9a
  patch do
    on_macos do
      file "Patches/ccache/fix-tests-xcode27.diff"
      type :unofficial
    end
  end

  deny_network_access!

  def install
    # Homebrew-specific workaround due to macOS sandbox blocking Unix socket in /tmp
    inreplace "test/CMakeLists.txt", "addtest(remote_helper)", "# \\0" if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DENABLE_IPO=TRUE",
                    "-DREDIS_STORAGE_BACKEND=ON",
                    "-DDEPS=LOCAL",
                    *std_cmake_args
    system "cmake", "--build", "build"

    # Homebrew compiler shim actively prevents ccache usage (see caveats), which will break the test suite.
    # We run the test suite for ccache because it provides a more in-depth functional test of the software
    # (especially with IPO enabled), adds negligible time to the build process, and we don't actually test
    # this formula properly in the test block since doing so would be too complicated.
    # See https://github.com/Homebrew/homebrew-core/pull/83900#issuecomment-90624064
    with_env(CC: DevelopmentTools.locate(DevelopmentTools.default_compiler)) do
      system "ctest", "-j#{ENV.make_jobs}", "--test-dir", "build", "--rerun-failed", "--output-on-failure"
    end

    system "cmake", "--install", "build"

    libexec.mkpath

    %w[
      clang
      clang++
      cc
      gcc gcc2 gcc3 gcc-3.3 gcc-4.0
      gcc-4.2 gcc-4.3 gcc-4.4 gcc-4.5 gcc-4.6 gcc-4.7 gcc-4.8 gcc-4.9
      gcc-5 gcc-6 gcc-7 gcc-8 gcc-9 gcc-10 gcc-11 gcc-12 gcc-13 gcc-14
      gcc-15
      c++ c++3 c++-3.3 c++-4.0
      c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9
      c++-5 c++-6 c++-7 c++-8 c++-9 c++-10 c++-11 c++-12 c++-13 c++-14
      c++-15
      g++ g++2 g++3 g++-3.3 g++-4.0
      g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9
      g++-5 g++-6 g++-7 g++-8 g++-9 g++-10 g++-11 g++-12 g++-13 g++-14
      g++-15
      i686-w64-mingw32-gcc i686-w64-mingw32-g++
      x86_64-w64-mingw32-gcc x86_64-w64-mingw32-g++
    ].each do |prog|
      libexec.install_symlink bin/"ccache" => prog
    end
  end

  def caveats
    <<~EOS
      To install symlinks for compilers that will automatically use
      ccache, prepend this directory to your PATH:
        #{opt_libexec}

      If this is an upgrade and you have previously added the symlinks to
      your PATH, you may need to modify it to the path specified above so
      it points to the current version.

      NOTE: ccache can prevent some software from compiling.
      ALSO NOTE: The brew command, by design, will never use ccache.
    EOS
  end

  test do
    ENV.prepend_path "PATH", opt_libexec
    assert_equal "#{opt_libexec}/gcc", shell_output("which gcc").chomp
    assert_match etc.to_s, shell_output("#{bin}/ccache --show-stats --verbose")

    # Calling `--help` can catch issues with fmt upgrades.
    # https://github.com/orgs/Homebrew/discussions/5830
    system bin/"ccache", "--help"

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main(void) {
        printf("hello, world");
        return 0;
      }
    C

    # Test that we link with xxhash correctly.
    assert_equal "6ef4b356229ca145dca726e94e88ad10", shell_output("#{bin}/ccache --checksum-file test.c").chomp
    # Test that we link with blake3 correctly.
    file_hash = shell_output("#{bin}/ccache --hash-file test.c").chomp
    assert_equal "5af36887ca2b2b6417c49cb073acfd7cdb37bbcf", file_hash

    system bin/"ccache", ENV.cc, "-c", "test.c"
    system bin/"ccache", "debug=true", ENV.cc, "-c", "test.c"

    input_text = testpath.glob("test.o.*.ccache-input-text").first.read
    assert_match File.basename(ENV.cc), input_text
    assert_match "test.c", input_text
    assert_match "### sourcecode hash", input_text
    assert_match file_hash, input_text

    # The format of the log file seems to differ on Linux.
    # It's not clear how to make the assertion below work for it.
    return unless OS.mac?

    log = testpath.glob("test.o.*.ccache-log").first
    assert_match "cache hit", log.read
  end
end
