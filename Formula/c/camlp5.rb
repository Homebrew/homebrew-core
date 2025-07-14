class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/8.03.01.tar.gz"
  sha256 "057b8e06590cf29a1bd22b6c83aa5daa816d5cbb2ba2548409d474d7dc10c5b8"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:rel[._-]?)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "8eb1bd182dff1a1f93c7cad292a550a0ff6a7700dd383d344e605661413b1f73"
    sha256 arm64_sonoma:  "2b7feece68d3595e22218a9532a50cad7a835bf55555b8ae2acbe0aa001b206a"
    sha256 arm64_ventura: "baac175d9fc1d95967bbd534fe163ed06461993f1fffa2a601c5a2daeb960942"
    sha256 sonoma:        "32bedf850db730633846714e007e702464370f6bfe5018bc387ee3e55744466e"
    sha256 ventura:       "b42b8272468115f0bc0fc793937a41f965dd09bf2cabd548d7fcbd974433042c"
    sha256 arm64_linux:   "a14a8a05c46c73c75f98bac84679db564a38f59d064401aebed5a8bf6d4e5299"
    sha256 x86_64_linux:  "40fdc0d4a01d13250fc2dfa8b8c1d7feaac99894e6deecd74b662d0dca58b812"
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
