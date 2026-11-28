class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/8.05.04.tar.gz"
  sha256 "bb82054e68bdb6343736a7ec0c29964341b3a3cb6c183b21479bbe4fb9d8dd45"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url "https://opam.ocaml.org/packages/camlp5/"
    regex(%r{href=.*?/refs/tags/(?:rel[._-]?)?v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    manifest_sha256 "a9295e9850358363fd6328f8df903a95ebb288f50d85518d87f02a2c0f2f68b4"
    sha256 arm64_golden_gate: "6771dc7b70f5289a0a8fa81a55bbe9782b7ece975de3ddf5de026e375140d05d"
    sha256 arm64_tahoe:       "843f00c1252c768ba1fd87f581e7ef1874f07af6e66c43e43cf560957678ff19"
    sha256 arm64_sequoia:     "fe8c2a8c46beca27c0605b2a30e204dc611f9842f41453cfbc9f3181edd79222"
    sha256 arm64_linux:       "68b3ed0ac70d117275dd5c6ee43d03c596df14c28dd3e8b5c0a337862648fa41"
    sha256 x86_64_linux:      "c484f61bce9e981a355a2e87f0d916c71fda11a9f2cba2130f8ce6f2df00a695"
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
