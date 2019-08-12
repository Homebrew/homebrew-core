class Infer < Formula
  desc "Static analyzer for Java, C, C++, and Objective-C"
  homepage "https://fbinfer.com/"
  # pull from git tag to get submodules
  url "https://github.com/facebook/infer.git",
      :tag      => "v0.17.0",
      :revision => "99464c01da5809e7159ed1a75ef10f60d34506a4"

  bottle do
    cellar :any
    sha256 "0b056e3162e0e5c791173f790e5e06dda2f80781531098ca8c6eb3d89dc96768" => :high_sierra
    sha256 "91c68a2e6487e2218567a2e92c10b76bbfea5c69497b1bd9b027426ed23ec615" => :sierra
    sha256 "8bb9d822db58e8b34e286dbc167c391e497ae5e37d96766ca355dd9bc7e6ec50" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "gmp" => :build
  depends_on :java => ["1.7+", :build, :test]
  depends_on "libtool" => :build
  depends_on "mpfr" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build

  def install
    # needed to build clang
    ENV.permit_arch_flags

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    opamroot = buildpath/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    # do not attempt to use the clang in facebook-clang-plugins/ as it hasn't been built yet
    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --without-fcp-clang"

    llvm_args = %w[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_C_FLAGS=#{ENV.cflags}
      -DCMAKE_CXX_FLAGS=#{ENV.cppflags}
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_SHARED_LINKER_FLAGS=#{ENV.ldflags}
      -DLIBOMP_ARCH=x86_64
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=On
      -DLLVM_BUILD_LLVM_DYLIB=On
      -DLLVM_ENABLE_ASSERTIONS=Off
      -DLLVM_ENABLE_EH=On
      -DLLVM_ENABLE_LIBCXX=On
      -DLLVM_ENABLE_RTTI=On
      -DLLVM_INCLUDE_DOCS=Off
      -DLLVM_INSTALL_UTILS=Off
      -DLLVM_TARGETS_TO_BUILD=all
    ]

    inreplace "facebook-clang-plugins/clang/setup.sh", "CMAKE_ARGS=(", "CMAKE_ARGS=(\n  " + llvm_args.join("\n  ")

    # so that `infer --version` reports a release version number
    inreplace "infer/src/base/Version.ml.in", "@IS_RELEASE_TREE@", "yes"

    # setup opam (disable opam sandboxing, since it will otherwise fail inside homebrew sandbox)
    # disabling sandboxing inside a sandboxed environment is necessary as of opam 2.0
    inreplace "build-infer.sh", "--no-setup", "--no-setup --disable-sandboxing"
    # prefer system bins configuring opam dependency mlgmpidl (needs to use system clang+ranlib+libtool)
    # if some homebrew versions of these mix with system tools, it can break compilation
    inreplace "build-infer.sh", "opam install", "PATH=/usr/bin:$PATH\n    opam install"

    pathfix_lines = [
      "export SDKROOT=#{MacOS.sdk_path}",
      "eval $(opam env)",
    ]

    # need to set sdkroot for clang to see certain system headers
    inreplace "build-infer.sh", "./configure $INFER_CONFIGURE_OPTS", pathfix_lines.join("\n") + "\n./configure $INFER_CONFIGURE_OPTS"

    system "./build-infer.sh", "all", "--yes"
    system "opam", "config", "exec", "--", "make", "install"

    # opam switches contain lots of files for end-user usage
    # much can be removed if all we need is a package
    opam_switch = File.read("build-infer.sh").match(/INFER_OPAM_DEFAULT_SWITCH=\"([^\"]+)\"/)[1]
    cd libexec/"opam" do
      # remove everything but the opam switch used for infer
      rm_rf Dir["*"] - [opam_switch.to_s]

      # remove everything in the switch but the dylibs infer needs during runtime
      cd opam_switch.to_s do
        rm_rf Dir["*"] - ["share"]

        cd "share" do
          rm_rf Dir["*"] - ["apron", "elina"]
        end
      end
    end
  end

  test do
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

    shell_output("#{bin}/infer --fail-on-issue -- clang -c FailingTest.c", 2)
    shell_output("#{bin}/infer --fail-on-issue -- clang -c PassingTest.c")

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

    shell_output("#{bin}/infer --fail-on-issue -- javac FailingTest.java", 2)
    shell_output("#{bin}/infer --fail-on-issue -- javac PassingTest.java")
  end
end
