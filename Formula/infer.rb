class Infer < Formula
  desc "Static analyzer for Java, C, C++, and Objective-C"
  homepage "https://fbinfer.com/"
  # pull from git tag to get submodules
  url "https://github.com/facebook/infer.git",
      :tag      => "v0.16.0",
      :revision => "4a91616390c058382c703f47653adfaecd31a7d7"

  bottle do
    cellar :any
    sha256 "0b056e3162e0e5c791173f790e5e06dda2f80781531098ca8c6eb3d89dc96768" => :high_sierra
    sha256 "91c68a2e6487e2218567a2e92c10b76bbfea5c69497b1bd9b027426ed23ec615" => :sierra
    sha256 "8bb9d822db58e8b34e286dbc167c391e497ae5e37d96766ca355dd9bc7e6ec50" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "camlp4" => :build
  depends_on "cmake" => :build
  depends_on "gnu-sed" => :build
  depends_on :java => ["1.7+", :build]
  depends_on "libtool" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on :x11 => :build
  depends_on :xcode => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@2"
  depends_on "sqlite"

  def install
    # needed to build clang
    ENV.permit_arch_flags

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["sqlite"].opt_lib/"pkgconfig"

    # opamroot = HOMEBREW_CACHE/"opam"
    opamroot = libexec/"opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    configure_args = %W[
      --prefix=#{prefix}
      --with-fcp-clang
    ]

    llvm_args = %w[
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INSTALL_UTILS=OFF
      -DLIBOMP_ARCH=x86_64
    ]

    # infer 0.16.0: ocaml_version = ocaml-variants.4.07.1+flambda
    ocaml_version = File.read("build-infer.sh").match(/INFER_OPAM_DEFAULT_SWITCH=\"([^\"]+)\"/)[1]

    # infer 0.16.0: mlgmpidl_version = 1.2.7
    mlgmpidl_version = File.read("opam.locked").match(/mlgmpidl\".+\"(.+)\"/)[1]
    # infer 0.16.0: ocamlbuild_version = 0.12.0
    ocamlbuild_version = File.read("opam.locked").match(/\"ocamlbuild\".+\"(.+)\"/)[1]

    # so that `infer --version` reports a release version number
    inreplace "infer/src/base/Version.ml.in", "@IS_RELEASE_TREE@", "yes"

    # setup opam (disable opam sandboxing because homebrew is sandboxed already)
    system "opam", "init", "--bare", "--no-setup", "--disable-sandboxing"
    system "opam", "switch", "create", ocaml_version.to_s

    # install some packages with care: mlgmpidl gets confused with certain homebrew tools in PATH
    system "opam", "install", "ocamlbuild=#{ocamlbuild_version}"
    original_path = ENV["PATH"]
    ENV["PATH"] = "/usr/bin:" + ENV["PATH"]
    system "opam", "install", "mlgmpidl=#{mlgmpidl_version}"
    ENV["PATH"] = original_path
    system "opam", "install", "utop"
    system "opam", "install", "--deps-only", "infer", buildpath, "--locked"

    inreplace "facebook-clang-plugins/clang/setup.sh", "CMAKE_ARGS=(", "CMAKE_ARGS=(\n  " + llvm_args.join("\n  ")
    system "facebook-clang-plugins/clang/setup.sh"

    system "./autogen.sh"

    # do NOT set this before ocaml packages are built (needed for clang includes)
    ENV["SDKROOT"] = MacOS.sdk_path

    system "opam", "config", "exec", "--", "./configure", *configure_args
    system "opam", "config", "exec", "--", "make"
    system "opam", "config", "exec", "--", "make", "install"
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

    # shell_output("#{bin}/infer --fail-on-issue -- javac FailingTest.java", 2)
    shell_output("#{bin}/infer --fail-on-issue -- javac PassingTest.java")
  end
end
