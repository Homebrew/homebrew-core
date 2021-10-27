class Infer < Formula
  desc "Static analyzer for Java, C, C++, and Objective-C"
  homepage "https://fbinfer.com/"
  license "MIT"
  revision 1
  head "https://github.com/facebook/infer.git", branch: "main"

  stable do
    url "https://github.com/facebook/infer/archive/v1.1.0.tar.gz"
    sha256 "201c7797668a4b498fe108fcc13031b72d9dbf04dab0dc65dd6bd3f30e1f89ee"

    # Fix FileUtils.cpp:44:57: error: invalid initialization of reference of type 'const string& ...
    # Remove in the next release.
    patch do
      url "https://github.com/facebook/infer/commit/c90ec0683456e0f03135e7c059a1233351440736.patch?full_index=1"
      sha256 "516585352727c5372c4d4582ed9a64bc12e7a9eb59386aa3cec9908f0cfc86a8"
    end

    # Apply patch for finding correct C++ header from Apple SDKs.
    # Remove in the next release.
    patch do
      url "https://github.com/facebook/infer/commit/ec976d3be4e78dbbb019b3be941066f74e826880.patch?full_index=1"
      sha256 "4f299566c88dd5b6761d36fcb090d238c216d3721dde9037c725dac255be9d3b"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:      "2c27006c4ccbc05c6bb405c626d188e2dd5ca183a0a2f4441385def480ba4f34"
    sha256 cellar: :any, catalina:     "7a2816d33cea3053531f51402e0145e4e8ee7537570ba2a580c3ef8aaff379fc"
    sha256 cellar: :any, mojave:       "2bda6a47ff87c9d79a3f937c9cf24771798107c1bc215823e6156d6ba414f40d"
    sha256               x86_64_linux: "987d26d95d3e073a96c683710ab0298a1674d2ee6e7a2ee4cb0d8914f2b0139d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  depends_on "opam" => :build
  depends_on "openjdk@11" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "sqlite"

  # Add `llvm` for lld due to CMake bug where CC=clang doesn't fallback to ld.
  # This causes error: /bin/sh: 1: CMAKE_LINKER-NOTFOUND: not found
  # CMake PR ref: https://gitlab.kitware.com/cmake/cmake/-/merge_requests/6457
  uses_from_macos "llvm" => :build # TODO: remove when `cmake` is fixed
  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build
  uses_from_macos "libedit"
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "elfutils" # openmp requires <gelf.h>
  end

  def install
    # needed to build clang
    ENV.permit_arch_flags

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    # Use JDK11
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    opamroot = buildpath/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    ENV["OPAMVERBOSE"] = "1"
    ENV["PATCHELF"] = Formula["patchelf"].opt_bin/"patchelf" if OS.linux?

    system "opam", "init", "--no-setup", "--disable-sandboxing"

    # do not attempt to use the clang in facebook-clang-plugins/ as it hasn't been built yet
    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --without-fcp-clang"

    # Let's try build clang faster
    ENV["JOBS"] = ENV.make_jobs.to_s

    # Release build
    touch ".release"

    # Disable handling external dependencies as opam is not aware of Homebrew on Linux.
    # Error:  Package conflict!  * Missing dependency:  - conf-autoconf
    inreplace "build-infer.sh", "infer \"$INFER_ROOT\" $locked", "\\0 --no-depexts" if OS.linux?

    system "./build-infer.sh", "all", "--yes"
    system "make", "install-with-libs"
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    ENV.append_path "PATH", Formula["openjdk@11"].opt_bin

    (testpath/"FailingTest.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int *s = NULL;
        *s = 42;
        return 0;
      }
    EOS

    (testpath/"PassingTest.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int *s = NULL;
        if (s != NULL) {
          *s = 42;
        }
        return 0;
      }
    EOS

    no_issues_output = "\n  No issues found  \n"

    failing_c_output = <<~EOS

      FailingTest.c:5: error: Null Dereference
      \  pointer `s` last assigned on line 4 could be null and is dereferenced at line 5, column 3.
      \  3. int main() {
      \  4.   int *s = NULL;
      \  5.   *s = 42;
      \       ^
      \  6.   return 0;
      \  7. }


      Found 1 issue
      \          Issue Type(ISSUED_TYPE_ID): #
      \  Null Dereference(NULL_DEREFERENCE): 1
    EOS

    assert_equal failing_c_output.to_s,
      shell_output("#{bin}/infer --fail-on-issue -P -- clang -c FailingTest.c", 2)

    assert_equal no_issues_output.to_s,
      shell_output("#{bin}/infer --fail-on-issue -P -- clang -c PassingTest.c")

    (testpath/"FailingTest.java").write <<~EOS
      class FailingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s.length();
        }
      }
    EOS

    (testpath/"PassingTest.java").write <<~EOS
      class PassingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s == null ? 0 : s.length();
        }
      }
    EOS

    failing_java_output = <<~EOS

      FailingTest.java:12: error: Null Dereference
      \  object `s` last assigned on line 11 could be null and is dereferenced at line 12.
      \  10.     int mayCauseNPE() {
      \  11.       String s = mayReturnNull(0);
      \  12. >     return s.length();
      \  13.     }
      \  14.   }


      Found 1 issue
      \          Issue Type(ISSUED_TYPE_ID): #
      \  Null Dereference(NULL_DEREFERENCE): 1
    EOS

    assert_equal failing_java_output.to_s,
      shell_output("#{bin}/infer --fail-on-issue -P -- javac FailingTest.java", 2)

    assert_equal no_issues_output.to_s,
      shell_output("#{bin}/infer --fail-on-issue -P -- javac PassingTest.java")
  end
end
