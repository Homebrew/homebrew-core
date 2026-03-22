class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.13.1/ccache-4.13.1.tar.xz"
  sha256 "85638df95c4d3907d9dd686583f2e0b2bd4c232d36e025a5c48e91524b491c4b"
  license "GPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/ccache/ccache.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "6078aefbbdbebc767fb48273ca27fc379b33d5719cdc0e3f066759b253ed0280"
    sha256               arm64_sequoia: "b72e7d2ff8be844e5b8139b79e0ce25a4afc470a2673889e83ed7e60d3ba3aff"
    sha256               arm64_sonoma:  "dd840a7f3afa68830cf1329ca354d7d3b22f38d8d5a4357f64e44c29611da0dd"
    sha256 cellar: :any, sonoma:        "5f197f67ab1745a6351b130332e537ebb2a9bcf366cb04df809c51c46aec7273"
    sha256               arm64_linux:   "d2964988264a5e2da4745b70911afffaf5af179495cacbfce3ae500857a85ea3"
    sha256               x86_64_linux:  "a5cd4c872b8bd80a57338e4a4d814fcf6b85bdc3a33dad86b0857515726d39ff"
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
  depends_on "xxhash"
  depends_on "zstd"

  def install
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
      system "ctest", "-j#{ENV.make_jobs}", "--test-dir", "build"
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
    # TODO: `--hash-file` and `ccache-input-text` does not match for now, needs to check it can be matched again.
    # ref: https://github.com/ccache/ccache/pull/1672
    # assert_match file_hash, input_text
    assert_match "5af3d23skapbcgbs975geemfqv6r6utsu", input_text

    # The format of the log file seems to differ on Linux.
    # It's not clear how to make the assertion below work for it.
    return unless OS.mac?

    log = testpath.glob("test.o.*.ccache-log").first
    assert_match "cache hit", log.read
  end
end
