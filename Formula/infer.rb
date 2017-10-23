class Infer < Formula
  desc "Static analyzer for Java, C, C++, and Objective-C"
  homepage "http://fbinfer.com/"
  # pull from git tag to get submodules
  url "https://github.com/facebook/infer.git",
      :tag => "v0.13.0",
      :revision => "ddda04c92b03dc86a0c32feaf8544f23874de4b3"

  bottle do
    cellar :any
    sha256 "57643d1549a778596cce9a4926298dd4adafea4c12995a14564a8fd4dc07a563" => :sierra_or_later
    sha256 "667715c360743f6f3d865043da3ce423baf123f3a5e6e775ac16fb9d5e839333" => :el_capitan
    sha256 "607cc291dbc3aa11836b975d2bcc47b7f700c9fbcf4ae83910312baed9ef0843" => :yosemite
  end

  option "without-clang", "Build without the C/C++/Objective-C analyzers"
  option "without-java", "Build without the Java analyzers"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build

  def install
    if build.without?("clang") && build.without?("java")
      odie "infer: --without-clang and --without-java are mutually exclusive"
    end

    # fix symbol not found issue (_clock_gettime) on el_capitan
    ENV.delete("SDKROOT")

    if build.with?("clang")
      # needed to build clang
      ENV.permit_arch_flags
      # Apple's libstdc++ is too old to build LLVM
      ENV.libcxx if ENV.compiler == :clang
    end

    opamroot = buildpath/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    # Some of the libraries installed by ./build-infer.sh do not
    # support parallel builds, eg OCaml itself. ./build-infer.sh
    # builds in its own parallelization logic to mitigate that.
    ENV.deparallelize

    # do not attempt to use the clang in facebook-clang-plugins/ as it hasn't been built yet
    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --disable-ocaml-binannot --without-fcp-clang"

    target_platform = if build.without?("clang")
      "java"
    elsif build.without?("java")
      "clang"
    else
      "all"
    end

    system "opam", "init", "--no-setup"
    ocaml_version = File.read("build-infer.sh").match(/OCAML_VERSION=\${OCAML_VERSION:-\"([^\"]+)\"}/)[1]
    ocaml_version_number = ocaml_version.split("+", 2)[0]
    inreplace "#{opamroot}/compilers/#{ocaml_version_number}/#{ocaml_version}/#{ocaml_version}.comp",
      '["./configure"', '["./configure" "-no-graph"'
    # so that `infer --version` reports a release version number
    inreplace "infer/src/base/Version.ml.in", "let is_release = is_yes \"@IS_RELEASE_TREE@\"", "let is_release = true"
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
