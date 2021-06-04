class Infer < Formula
  desc "Static analyzer for Java, C, C++, and Objective-C"
  homepage "https://fbinfer.com/"
  url "https://github.com/facebook/infer/archive/v1.1.0.tar.gz"
  sha256 "201c7797668a4b498fe108fcc13031b72d9dbf04dab0dc65dd6bd3f30e1f89ee"
  license "MIT"
  head "https://github.com/facebook/infer.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "e3f2d774f27d1daac2b41ed5cb2bcf1b180f9b6d6440ae5ddfb8d1c001c4413a"
    sha256 cellar: :any, catalina: "2dcd6c8c088ee88b21f3740a770fd3f73850815aa1f9270d814bfdd4095d2fc4"
    sha256 cellar: :any, mojave:   "b1e1ea3fd12e96a325ca3a5618032a0f9289caae1704afcab131b87a2104ad84"
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

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "patchelf" => :build
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
    on_linux do
      ENV["PATCHELF"] = Formula["patchelf"].opt_bin/"patchelf"
    end

    system "opam", "init", "--no-setup", "--disable-sandboxing"

    # do not attempt to use the clang in facebook-clang-plugins/ as it hasn't been built yet
    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --without-fcp-clang"

    # Let's try build clang faster
    ENV["JOBS"] = ENV.make_jobs.to_s

    # Release build
    touch ".release"

    system "./build-infer.sh", "all", "--yes"
    system "make", "install-with-libs"
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

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
