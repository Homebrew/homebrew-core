class CamlpStreams < Formula
  desc "Stream and Genlex libraries for use with Camlp4 and Camlp5"
  homepage "https://github.com/ocaml/camlp-streams"
  url "https://github.com/ocaml/camlp-streams/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "ad71f62406e9bb4e7fb5d4593ede2af6c68f8b0d96f25574446e142c3eb0d9a4"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1ab3f2156883e27bcfeff416cccb5e6f5e32102a52640299c5d6ca561b0b09f4"
    sha256 cellar: :any,                 arm64_ventura:  "ee43234549a20178bcc759f2b630f68869c956527061079b3203091358c49195"
    sha256 cellar: :any,                 arm64_monterey: "c88d7c4203e0111c6f21c6db54bfeb963e7962025741659d827a4153a096f3e0"
    sha256 cellar: :any,                 sonoma:         "909acae960bc459db4f9f721801086296809a7b85db919229cc26ae67457f92e"
    sha256 cellar: :any,                 ventura:        "e57d2a7c4e1ed7d865c72f6e0699a5e8439b22b76cff119ca10f41ccaf38ac92"
    sha256 cellar: :any,                 monterey:       "584919e25737e013998be682d4cb0b79a512dd37180444e134f853c254586fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c23521a07bf157dc5f7fd018fdc804149a5e4c4acb375db87f1396bf50a1321c"
  end

  depends_on "dune" => :build
  depends_on "ocaml-findlib" => :test
  depends_on "ocaml"

  def install
    system "dune", "build", "@install"
    system "dune", "install", "--prefix=#{prefix}", "--libdir=#{lib}/ocaml", "--docdir=#{doc.parent}"
  end

  test do
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end

    (testpath/"test.ml").write <<~EOS
      let stream = Stream.of_list ([] : unit list)
    EOS
    system "ocamlfind", "ocamlopt", "-linkpkg", "-package", "camlp-streams",
                                    "-warn-error", "+3", "-o", "test", "test.ml"
    assert_predicate testpath/"test", :exist?
  end
end
