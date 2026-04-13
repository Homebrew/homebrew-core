class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http://projects.camlcity.org/projects/findlib.html"
  url "https://github.com/ocaml/ocamlfind/archive/refs/tags/findlib-1.9.8.tar.gz"
  sha256 "d6899935ccabf67f067a9af3f3f88d94e310075d13c648fa03ff498769ce039d"
  license "MIT"
  revision 3

  livecheck do
    url "https://opam.ocaml.org/packages/ocamlfind/"
    regex(/href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "b690ccd47c921760a3fd174d89de314aa63a417db08f3762af5931450b993703"
    sha256               arm64_sequoia: "f8eab8fc29b9a4ad8c18baddaaa04b79af5baa4a8286d116fc575548045c045b"
    sha256               arm64_sonoma:  "83c91809db7f64c9fecc52ba362bf77d204200a5465f8c1f8855e484fe4e9549"
    sha256 cellar: :any, sonoma:        "0edf302c1fe0a1eb98dc206e8ecd200ba8427d7911de83fa07c75bca1ebc05f1"
    sha256               arm64_linux:   "05a6b6652cbdaf56349e566a394c4b8d12af6e90fd9a0be3f8752026f385179f"
    sha256               x86_64_linux:  "9749365e2bddc7e75a52a64f1405c56a78f7cbde07b630e93b89e640bbcabdb5"
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
    system Formula["ocaml"].opt_bin/"ocamlopt", "-I", lib/"ocaml/findlib", "-o", "test", "findlib.cmxa", "test.ml"
    system "./test"
  end
end
