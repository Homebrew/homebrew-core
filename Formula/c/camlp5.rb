class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/8.05.01.tar.gz"
  sha256 "7aa71c393cf4f24860051a5aa78da8925d73cb79ba045df442dff2343b1283d7"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url "https://opam.ocaml.org/packages/camlp5/"
    regex(%r{href=.*?/refs/tags/(?:rel[._-]?)?v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "5a94d909d184b49e53c16568d433a640de32532bdf074160bf49555a4ab67e4f"
    sha256 arm64_sequoia: "a1358d7b0af3b148ae2da1ed3b9151c6c62ac5ed31f3433de8ebf96c8914191d"
    sha256 arm64_sonoma:  "560065f1b9ea7468bdbf3eac1ea8706d53079d0a3b8e781edd9ebfd27f1d8bd4"
    sha256 sonoma:        "9f06e11758fef2de54d31ee5c38dc38df1bdacc25b42ddb9c78f64efb77477b0"
    sha256 arm64_linux:   "9f85fd511805dfebb2bda27fe6d375f0ac8e230c2185a3969c82e08c4f76f266"
    sha256 x86_64_linux:  "c0430741e1dd1dd2f71aafa8e134a4d50a99031863c3f607b4a021a656c393fc"
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
    (lib/"camlp5").install "etc/META"
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
      shell_output("#{bin}/camlp5 #{lib}/camlp5/pa_o.cmo " \
                   "#{lib}/camlp5/o_keywords.cmo " \
                   "#{lib}/camlp5/pr_o.cmo " \
                   "#{ocaml.opt_lib}/ocaml/str/str.cma hi.ml")
  end
end
