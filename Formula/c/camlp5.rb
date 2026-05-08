class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/8.05.00.tar.gz"
  sha256 "30e6b6faa91a7c448a17dc4ecde0448ae3a7d5ba5b2b057014149d27014a6481"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url "https://opam.ocaml.org/packages/camlp5/"
    regex(%r{href=.*?/refs/tags/(?:rel[._-]?)?v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "2fdb994f04bec3485130aee96483a96c255a4f74619b78b8e7f31a105b4c2855"
    sha256 arm64_sequoia: "f6dfd8724ff6cea9dcf4f20293fea0a25467724318950c9d5d4b15fb762c33f8"
    sha256 arm64_sonoma:  "b6ee53d7bd779d0c2b148785be2597df3398706fef3cc011754dd3836425d61b"
    sha256 sonoma:        "4e29b60a70f0ca63b913ff6d6c0472f6540b2ab97ec7cfb4cecbdf92a88ea583"
    sha256 arm64_linux:   "60361697d96922fdbe9a4e8d5d9b5f0ddd04658b00183f9cb22ece010437f441"
    sha256 x86_64_linux:  "424320c4773f5b183c9c38ee72ce47a9b10c8ed7e6edc437d96e065726c993de"
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
