class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/8.03.00.tar.gz"
  sha256 "0dae6d32184aca6f2cdbe818ee2f26aa58baa87d9e82f820914c63b35aa075de"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:rel[._-]?)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "351bc6f9bba7beebcd961e5bab9ebca32d8b4bd0507e1901cceb1e2930c6c493"
    sha256 arm64_ventura:  "be8a0d5f7f033e1b79e416654b5b3eccca3201f689726d42b408faff6c8f6fe3"
    sha256 arm64_monterey: "4eb4dbe6e3e66708c4e942e2ed10d90178cced35ea75367286c63b9ca21c07d5"
    sha256 sonoma:         "906ffd7b6316f20a10d349d1170752298aeb0191eac7dcff6c22c01fb7618005"
    sha256 ventura:        "23b352596c1e729f9094f5e05822d9c10b1a2b28e5c6d3b6bde5ae01d95c15a8"
    sha256 monterey:       "8f42fe3372d348d38f9f3272036967bf0e6425de81df130a6aeebf76842e4e20"
    sha256 x86_64_linux:   "6d732cb0df6a06f0f9ece5791d12169d032326ddb58306e17ea276d95abd3ebb"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "camlp-streams"
  depends_on "ocaml"

  uses_from_macos "m4" => :build

  def install
    opamroot = buildpath/".opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--no-setup", "--disable-sandboxing"
    system "opam", "exec", "--", "opam", "install", ".", "--deps-only", "-y", "--no-depexts"

    system "./configure", "--prefix", prefix, "--mandir", man
    system "opam", "exec", "--", "make", "world.opt"
    system "opam", "exec", "--", "make", "install"
    (lib/"ocaml/camlp5").install "etc/META"
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
