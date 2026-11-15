class CamlpStreams < Formula
  desc "Stream and Genlex libraries for use with Camlp4 and Camlp5"
  homepage "https://github.com/ocaml/camlp-streams"
  url "https://github.com/ocaml/camlp-streams/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "ad71f62406e9bb4e7fb5d4593ede2af6c68f8b0d96f25574446e142c3eb0d9a4"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 9
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9ebe9ddfd875fb22f45f25ff0709fa92b5e3074068ac0726e0590bf3e48318cc"
    sha256 cellar: :any, arm64_tahoe:       "a5c519c377b6436f0d1c2936eb7ffd60508528e7b84cfcc16f439fbf5c9a6b6c"
    sha256 cellar: :any, arm64_sequoia:     "c70602c608ec248880aebee12d42f4aeb69403b6ce62137adc78e0953500c70b"
    sha256 cellar: :any, arm64_linux:       "78e283cd0b41018d1a1fdc2fdd676a800090300133982ed3d9a20605da586a20"
    sha256 cellar: :any, x86_64_linux:      "9ee5e440faa3f86571c01e8d8035f003fbf3ca7949ff6082edca8a5d6f1e68c8"
  end

  depends_on "dune" => :build
  depends_on "ocaml-findlib" => :test
  depends_on "ocaml"

  def install
    # Use the release profile like opam so `Stream` matches copies bundled by other formulae
    system "dune", "build", "-p", name, "@install"
    system "dune", "install", "--prefix=#{prefix}", "--libdir=#{lib}/ocaml", "--docdir=#{doc.parent}"
  end

  test do
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = formula_opt_libexec("ocaml-findlib")/"findlib.conf"
    end

    (testpath/"test.ml").write <<~OCAML
      let stream = Stream.of_list ([] : unit list)
    OCAML
    system "ocamlfind", "ocamlopt", "-linkpkg", "-package", "camlp-streams",
                                    "-warn-error", "+3", "-o", "test", "test.ml"
    assert_path_exists testpath/"test"
  end
end
