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
    rebuild 1
    sha256 arm64_tahoe:   "177918da0e18160f266ff72f36207ab0e2400064bd8af57e19d8e6f2201639f3"
    sha256 arm64_sequoia: "a8d26e5584cfa10b9134b32810973d7609ed309df3096b2eaff633d89ccb526b"
    sha256 arm64_sonoma:  "9b360c9971322cd2f08cad30e1aad3a5095cdd31ddd2b7367841b2abd4910a7e"
    sha256 sonoma:        "1d2860a5ceb227d268ec5b2ea2138d72e5eedc4765620ab7268f12b86fe4947b"
    sha256 arm64_linux:   "a502e19ab5426f0e9a7f9a2f2e1e6853d7826e8fe8f4cb94c0e34a591a71c0e2"
    sha256 x86_64_linux:  "215a197c95d790cb24d50c6f55a82bbe84b2de7beaf9ac5039ad680bb04a83dc"
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
