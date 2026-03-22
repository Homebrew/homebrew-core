class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/8.04.00.tar.gz"
  sha256 "eb8c5bc0f47ce4b9518d37bcbf8be05ee80243c38e7019f8c3808456be8f15a8"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url "https://opam.ocaml.org/packages/camlp5/"
    regex(%r{href=.*?/refs/tags/(?:rel[._-]?)?v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "61dc0c7d0bf2a5e91afcba91ce127172c6ad3e2cd64d18950875ea6e914433f5"
    sha256 arm64_sequoia: "2c10995a40dac4ff4e5686d498ea76a4c680b5e0ac0d2d4e26992e3488e94fa6"
    sha256 arm64_sonoma:  "3a07acb738d7410fa991e69d9bf9ee454c152c21060a1989715c6ce8db80c4a9"
    sha256 sonoma:        "83822f4200ee229c2d9c46b5c650efd37aba4cd0f73dc1effc815b841b649986"
    sha256 arm64_linux:   "9037191c4e95682c02785002444fd5cbbea75035025216a49cecda6bb60b92f7"
    sha256 x86_64_linux:  "a4411131337232c2a85b7dc0153fcc020ea43b177991952fe6bea444fd4f4cc7"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "camlp-streams"
  depends_on "ocaml"
  depends_on "pcre2"

  uses_from_macos "m4" => :build

  def install
    ENV["OPAMROOT"] = opamroot = buildpath/".opam"
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", ".", "--deps-only", "--yes", "--no-depexts"

    system "./configure", "--prefix", prefix, "--mandir", man
    system "opam", "exec", "--", "make", "world.opt"
    system "opam", "exec", "--", "make", "install"
    (lib/"ocaml/camlp5").install "etc/META"
    libexec.install opamroot/"ocaml-system/lib/stublibs/dllpcre2_stubs.so"
    bin.env_script_all_files libexec, CAML_LD_LIBRARY_PATH: libexec
  end

  test do
    ocaml = Formula["ocaml"]
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"",
      # The purpose of linking with the file "str.cma" is to ensure that the
      # ocaml files are in sync with the camlp5 files.  If camlp5 has been
      # compiled with an older version of the ocaml compiler, then an error
      # "interface mismatch" will occur.
      shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo " \
                   "#{lib}/ocaml/camlp5/o_keywords.cmo " \
                   "#{lib}/ocaml/camlp5/pr_o.cmo " \
                   "#{ocaml.opt_lib}/ocaml/str/str.cma hi.ml")
  end
end
