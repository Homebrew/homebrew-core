class Infer < Formula
  desc "Static analyzer for Java, C and Objective-C"
  homepage "http://fbinfer.com/"
  url "https://github.com/facebook/infer/releases/download/v0.9.2/infer-osx-v0.9.2.tar.xz"
  sha256 "3935f8be25982a023aba306b66804d73a7316ab833296277c1ec6c3694bfc7c7"

  bottle do
    cellar :any
    sha256 "feb6fd20c3d964ea19e52d3182819c10d133c9505e959c2758c58beeb0640ae1" => :el_capitan
    sha256 "2dd905ed0bf9bf53195578d4b9b2d0e1902373cb8267f0ac38d08966d21668c7" => :yosemite
    sha256 "9ef2468c8129a84032c543e87c125a4a7c0d453058abd1f11f46eff07b17a360" => :mavericks
  end

  option "without-clang", "Build without C/Objective-C analyzer"
  option "without-java", "Build without Java analyzer"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "opam" => :build

  def install
    if build.without?("clang") && build.without?("java")
      odie "infer: --without-clang and --without-java are mutually exclusive"
    end

    opamroot = buildpath/"build"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    # Some of the libraries installed by ./build-infer.sh do not
    # support parallel builds, eg OCaml itself. ./build-infer.sh
    # builds in its own parallelization logic to mitigate that.
    ENV.deparallelize

    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --disable-ocaml-annot --disable-ocaml-binannot"

    target_platform = if build.without?("clang")
      "java"
    elsif build.without?("java")
      "clang"
    else
      "all"
    end

    system "./build-infer.sh", target_platform, "--yes"
    system "opam", "config", "exec", "--switch=infer-4.02.3", "--", "make", "install"
  end

  test do
    (testpath/"FailingTest.c").write <<-EOS.undent
      #include <stdio.h>

      int main() {
        int *s = NULL;
        *s = 42;

        return 0;
      }
    EOS

    (testpath/"PassingTest.c").write <<-EOS.undent
      #include <stdio.h>

      int main() {
        int *s = NULL;
        if (s != NULL) {
          *s = 42;
        }

        return 0;
      }
    EOS

    shell_output("#{bin}/infer --fail-on-bug -- clang FailingTest.c", 2)
    shell_output("#{bin}/infer --fail-on-bug -- clang PassingTest.c", 0)

    (testpath/"FailingTest.java").write <<-EOS.undent
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

    (testpath/"PassingTest.java").write <<-EOS.undent
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

    shell_output("#{bin}/infer --fail-on-bug -- javac FailingTest.java", 2)
    shell_output("#{bin}/infer --fail-on-bug -- javac PassingTest.java", 0)
  end
end
