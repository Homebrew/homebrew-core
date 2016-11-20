class Infer < Formula
  desc "Static analyzer for Java, C and Objective-C"
  homepage "http://fbinfer.com/"
  url "https://github.com/facebook/infer/releases/download/v0.9.4/infer-osx-v0.9.4.tar.xz"
  sha256 "529d147bccf3285ddb7500c22e0c50d6e0cbdb2c7f9b11a84e8005873994b3e2"

  bottle do
    cellar :any
    sha256 "eb729a19ba746d0f17535aded0a3c3fe74d0abcf0a0f2ae767c3b0ab3a58bf46" => :sierra
    sha256 "023b642c0b4959611f39f3029e36fbd301eca4bc87e1622778cdb6e2c5549fe2" => :el_capitan
    sha256 "a0dc0b8308aeda1540991393fef1568e074931070786414b07791176e741c922" => :yosemite
  end

  option "without-clang", "Build without C/Objective-C analyzer"
  option "without-java", "Build without Java analyzer"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build

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

    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --disable-ocaml-annot --disable-ocaml-binannot"

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
