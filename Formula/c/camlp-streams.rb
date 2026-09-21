class CamlpStreams < Formula
  desc "Stream and Genlex libraries for use with Camlp4 and Camlp5"
  homepage "https://github.com/ocaml/camlp-streams"
  url "https://github.com/ocaml/camlp-streams/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "ad71f62406e9bb4e7fb5d4593ede2af6c68f8b0d96f25574446e142c3eb0d9a4"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 8

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "66cf6c6e906ebb2eeec62c375bfcf5ebfa3d5cc0625290818c89f1cbba13f7ce"
    sha256 cellar: :any, arm64_tahoe:       "4b27a1600ecf72abd834014cc1a0468123a43deb552b11be0f2b82590dee0ada"
    sha256 cellar: :any, arm64_sequoia:     "73488f091ea0410e729fac0a9f4ec29ca3cfd6ecd9044b3b4425e1ac6be77cbe"
    sha256 cellar: :any, arm64_linux:       "ff202f7479a469d8d010c053420e5391b67742e760e4f721b76fdff7109dc919"
    sha256 cellar: :any, x86_64_linux:      "50f38409c827ecd178f56c167e2e64bc9d4cdf87effd918202301a2f54a4412b"
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
