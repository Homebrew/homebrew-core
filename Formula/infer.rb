class Infer < Formula
  desc "Static analyzer for Java, C and Objective-C"
  homepage "http://fbinfer.com/"
  url "https://github.com/facebook/infer/releases/download/v0.12.0/infer-osx-v0.12.0.tar.xz"
  sha256 "3b97bcabf85af8feb8d6fd0b8622fe2b4fbf27fa215fab61e3a660b5435b6d21"
  revision 1

  bottle do
    cellar :any
    sha256 "16da98afd4312582d219eaf62d6619567ee1df367d5b6b4e8e4e667e9b7908a2" => :sierra
    sha256 "a3de914afe3ffc5e65f46fc10516607d7a4614f5a2d476d47fd053cd662f43e4" => :el_capitan
    sha256 "8e97022052281a1e5681e9855a1d4cfe456c906897b20f10e0ef3b3e55d27443" => :yosemite
  end

  option "without-clang", "Build without C/Objective-C analyzer"
  option "without-java", "Build without Java analyzer"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build

  def install
    if build.without?("clang") && build.without?("java")
      odie "infer: --without-clang and --without-java are mutually exclusive"
    end

    opamroot = buildpath/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    # Some of the libraries installed by ./build-infer.sh do not
    # support parallel builds, eg OCaml itself. ./build-infer.sh
    # builds in its own parallelization logic to mitigate that.
    ENV.deparallelize

    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --disable-ocaml-binannot"

    target_platform = if build.without?("clang")
      "java"
    elsif build.without?("java")
      "clang"
    else
      "all"
    end

    system "opam", "init", "--no-setup"
    ocaml_version = File.read("build-infer.sh").match(/OCAML_VERSION=\"([0-9\.]+)\"/)[1]
    inreplace "#{opamroot}/compilers/#{ocaml_version}/#{ocaml_version}/#{ocaml_version}.comp",
      '["./configure"', '["./configure" "-no-graph"'
    system "./build-infer.sh", target_platform, "--yes"
    system "opam", "config", "exec", "--switch=infer-#{ocaml_version}", "--", "make", "install"
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

    shell_output("#{bin}/infer --fail-on-issue -- clang -c FailingTest.c", 2)
    shell_output("#{bin}/infer --fail-on-issue -- clang -c PassingTest.c", 0)

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

    shell_output("#{bin}/infer --fail-on-issue -- javac FailingTest.java", 2)
    shell_output("#{bin}/infer --fail-on-issue -- javac PassingTest.java", 0)
  end
end
