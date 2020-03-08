class Infer < Formula
  desc "Static analyzer for Java, C, C++, and Objective-C"
  homepage "https://fbinfer.com/"
  # pull from git tag to get submodules
  url "https://github.com/facebook/infer.git",
      :tag      => "v0.17.0",
      :revision => "99464c01da5809e7159ed1a75ef10f60d34506a4"

  bottle do
    cellar :any
    sha256 "b6e5941d9be1c640b2dd0430801be1b59eb91ddc56c9e8e454c45af01c812476" => :catalina
    sha256 "166a3baf77f343a2bdd43fb772b93bd3610d6baf4f1e39e8fc6aa83e46029ef8" => :mojave
    sha256 "c7bb9d37a9d77fbc2019ffd6f80ce7e7a3992c4ac0a95235c335ce61f43993e9" => :high_sierra
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
