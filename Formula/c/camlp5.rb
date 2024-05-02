class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/8.02.01.tar.gz"
  sha256 "58d4bce0c20fa1151fc2c15f172f5884472e2044a4b0da22aababf46c361e515"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:rel[._-]?)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b759ee090fbf543cdc3fc06316f6e49688031dadc5f596dcb7d202c5e9b6259d"
    sha256 arm64_ventura:  "fecb24a088b59346812faa716de555a939e6ff0efd38cec825ce4178834c3ba7"
    sha256 arm64_monterey: "6b9fb48113e2cb84683f72fa3744da3bbe00f483df59ea1e07016a2e06352a9f"
    sha256 sonoma:         "23da0a4d852c4d00da8523d2a2303b482dbddd40a9eb8d674f87907d9f718937"
    sha256 ventura:        "07d9c205a10282211954729926982a14215def6e5ebf511bba15a39d0f77adf4"
    sha256 monterey:       "582c31c1fd609b1904515b878ce4a2f886391a042ae6b9de6d595dabf832fda9"
    sha256 x86_64_linux:   "6dbd19efdc0c99cd9fb94ee55ce1b8d5f6ee12e73ae93a3146c5bdec602e04d3"
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
      shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo " \
                   "#{ocaml.opt_lib}/ocaml/str/str.cma hi.ml")
  end
end
