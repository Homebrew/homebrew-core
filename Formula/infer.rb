class Infer < Formula
  desc "Static analyzer for Java, C, C++, and Objective-C"
  homepage "https://fbinfer.com/"
  # pull from git tag to get submodules
  url "https://github.com/facebook/infer.git",
      :tag      => "v0.17.0",
      :revision => "99464c01da5809e7159ed1a75ef10f60d34506a4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1dc9c75c759611c8fe0efa8f63d7e55bbaa35d8dc2863f7a527069b11759f244" => :catalina
    sha256 "74b2dddff2bea362066395e28a797078d33514774511cc64771d0f89eea2466d" => :mojave
    sha256 "7630571f8e391ce0ba991ffe7a5d7b2b4a1029cda1d56497800d8ae0a260d4b6" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on :java => ["1.8", :build, :test]
  depends_on "libtool" => :build
  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build
  depends_on "ocaml-num" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "sqlite"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build
  uses_from_macos "ncurses"
  uses_from_macos "python@2" # python@2 dependency will be removed in https://github.com/facebook/infer/issues/934
  uses_from_macos "xz"
  uses_from_macos "zlib"

  # Remove camlp4 dependency, which is deprecated
  # Addressed in 0.18.x
  patch do
    url "https://github.com/facebook/infer/commit/f52b5fc981c692776210d7eb9681c2b8c3117c93.patch?full_index=1"
    sha256 "5487b9b39607c94821bede8d4f0ec2a0ed08d5213d5f048b1344819dac53b2f5"
  end

  def install
    # needed to build clang
    ENV.permit_arch_flags

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    opamroot = buildpath/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    ENV["OPAMVERBOSE"] = "1"

    system "opam", "init", "--no-setup", "--disable-sandboxing"

    # do not attempt to use the clang in facebook-clang-plugins/ as it hasn't been built yet
    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --without-fcp-clang"

    # Let's try build clang faster
    ENV["JOBS"] = ENV.make_jobs.to_s

    ENV["CLANG_CMAKE_ARGS"] = "-DLLVM_OCAML_INSTALL_PATH=#{`opam var lib`.chomp}/ocaml"

    # Release build
    touch ".release"

    # Pin updated dependencies which are required to build on brew ocaml
    # Remove from this when Infer updates their opam.locked to use at least these versions
    pinned_deps = {
      "mlgmpidl"  => "1.2.12",
      "octavius"  => "1.2.1",
      "parmap"    => "1.0-rc11",
      "ppx_tools" => "5.3+4.08.0",
    }
    pinned_deps.each { |dep, ver| system "opam", "pin", "add", dep, ver, "--locked" }

    # Unfortunately, opam can't cope if a system ocaml-num happens to be installed.
    # Instead, we depend on Homebrew's ocaml-num and fool opam into using it.
    # https://github.com/ocaml/opam-repository/issues/14646
    system "opam", "pin", "add", "ocamlfind", Formula["ocaml-findlib"].version.to_s, "--locked", "--fake"
    system "opam", "pin", "add", "num", Formula["ocaml-num"].version.to_s, "--locked", "--fake"

    # Relax the dependency lock on a specific ocaml
    # Also ignore anything we pinned above
    ENV["OPAMIGNORECONSTRAINTS"] = "ocaml,ocamlfind,num,#{pinned_deps.keys.join(",")}"

    # Remove ocaml-variants dependency (we won't be using it)
    inreplace "opam.locked", /^ +"ocaml-variants" {= ".*?"}$\n/, ""

    system "opam", "exec", "--", "./build-infer.sh", "all", "--yes", "--user-opam-switch"
    system "opam", "exec", "--", "make", "install-with-libs"
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

    shell_output("#{bin}/infer --fail-on-issue -P -- clang -c FailingTest.c", 2)
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

    shell_output("#{bin}/infer --fail-on-issue -P -- javac FailingTest.java", 2)
    shell_output("#{bin}/infer --fail-on-issue -P -- javac PassingTest.java")
  end
end
