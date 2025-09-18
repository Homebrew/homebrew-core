class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/8.03.01.tar.gz"
  sha256 "057b8e06590cf29a1bd22b6c83aa5daa816d5cbb2ba2548409d474d7dc10c5b8"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:rel[._-]?)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "33d7a8a87bac47b7c1a38d86163721b35b08a504c607fdaaf8e7b9cfb0d4a396"
    sha256 arm64_sequoia: "7959f6d3fa94680f0cfbd400e62278ca831ed6e9e172a799b92107521898e654"
    sha256 arm64_sonoma:  "b358f825630a28395859a8d24034710241ff0ba374bab42ebe8c453f7398755f"
    sha256 arm64_ventura: "a67366fe1a8eb1a88495973e2049d78151112a5d081803f3be2c6b0a38c4c616"
    sha256 sonoma:        "d6a7484e9535bad4b3e42e581e0c0da75f4f778852950255dc46b929c25cdce7"
    sha256 ventura:       "c2de76fb6bb6df777b902d91756821a5fb1718b7c5f2492599f492512b3285d7"
    sha256 arm64_linux:   "5063e6e6c30363bf5e58adda45472123ebef8a12daa36dbf04279db8f955baf2"
    sha256 x86_64_linux:  "7463bdc459d6b9a308f9598799f67fd6194f6070e5b4555b60a213dabd711d4c"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "opam" => :build
  depends_on "camlp-streams"
  depends_on "ocaml"

  uses_from_macos "m4" => :build

  def install
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", ".", "--deps-only", "--yes", "--no-depexts"

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
