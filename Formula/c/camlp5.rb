class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/8.05.03.tar.gz"
  sha256 "a56ef4afe3eb81ab3d8371f887779f8c0cee3b82c0ada7e066b723e51590f78c"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url "https://opam.ocaml.org/packages/camlp5/"
    regex(%r{href=.*?/refs/tags/(?:rel[._-]?)?v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "76e3889c55d2ad70e7b3fadfaaf5c1a114096549ee3fb4abdcebaad3ba4a6dc5"
    sha256 arm64_tahoe:       "7745ebec965e8f9d8795f65f1253ce935a1beeb9fe2b88fe3bc65fb0a14d44cd"
    sha256 arm64_sequoia:     "1c0ba5a0d5db137231c5f6c00f63912e8e8d0699b1312b65b1c53b26f99ca0f3"
    sha256 arm64_linux:       "57d77263deebf9ca46ed294b765257310e2acf6d12d2fa26cfd8edf86656ad26"
    sha256 x86_64_linux:      "f20d5e33d74d003a6b8f8e4629fc5c1b58820c3377faf2b06b34df354862579c"
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

    # OCaml 5.5.0 no longer exposes opam's C stubs (e.g. dllpcre2_stubs.so) for linking.
    # https://github.com/ocaml/opam-repository/issues/16406
    ENV.prepend_path "CAML_LD_LIBRARY_PATH", opamroot/"ocaml-system/lib/stublibs"

    system "./configure", "--prefix", prefix, "--libdir", lib/"ocaml", "--mandir", man
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
