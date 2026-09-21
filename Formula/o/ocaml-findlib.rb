class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "https://github.com/ocaml/ocamlfind/archive/refs/tags/findlib-1.9.8.tar.gz"
  sha256 "d6899935ccabf67f067a9af3f3f88d94e310075d13c648fa03ff498769ce039d"
  license "MIT"
  revision 5

  livecheck do
    url "https://opam.ocaml.org/packages/ocamlfind/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "48c376115d91af8e22c6f29cdb8d65b461ab5598b2ad0170692ad2984c117fa5"
    sha256 arm64_tahoe:       "8970bc6f56d6bbf45bc039ea34059d57ff34941ad755ab3b928b43a6414ed3a3"
    sha256 arm64_sequoia:     "c6f0ca3673fd3b5f2f577c3f4f9c6c735326a72c0e4c768a2e2dd7e0dd77cb57"
    sha256 arm64_linux:       "8a373191f68d6b013698ccc1e59632743189b6689f4009b2f606d4e59187ee26"
    sha256 x86_64_linux:      "b832f69955d82f69f6b6bfcc4c04cef749fb2028544f4383d678691c00ecc821"
  end

  depends_on "ocaml"

  uses_from_macos "m4" => :build

  def install
    # Specify HOMEBREW_PREFIX here so those are the values baked into the compile,
    # rather than the Cellar
    system "./configure", "-bindir", bin,
                          "-mandir", man,
                          "-sitelib", HOMEBREW_PREFIX/"lib/ocaml",
                          "-config", etc/"findlib.conf",
                          "-no-camlp4"

    system "make", "all"
    system "make", "opt"

    # Override the above paths for the install step only
    system "make", "install", "OCAML_SITELIB=#{lib}/ocaml",
                              "OCAML_CORE_STDLIB=#{lib}/ocaml"

    # Avoid conflict with ocaml-num package
    rm_r(Dir[lib/"ocaml/num", lib/"ocaml/num-top"])

    # Save extra findlib.conf to work around https://github.com/Homebrew/homebrew-test-bot/issues/805
    libexec.mkpath
    cp etc/"findlib.conf", libexec/"findlib.conf"
  end

  test do
    output = shell_output("#{bin}/ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/findlib", output.chomp

    # Check if we need to rebuild ocaml-findlib to be used as a library
    (testpath/"test.ml").write <<~OCAML
      open Findlib;;
      Findlib.init();
    OCAML
    system formula_opt_bin("ocaml")/"ocamlopt", "-I", lib/"ocaml/findlib", "-o", "test", "findlib.cmxa", "test.ml"
    system "./test"
  end
end
