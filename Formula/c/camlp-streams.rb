class CamlpStreams < Formula
  desc "Stream and Genlex libraries for use with Camlp4 and Camlp5"
  homepage "https://github.com/ocaml/camlp-streams"
  url "https://github.com/ocaml/camlp-streams/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "ad71f62406e9bb4e7fb5d4593ede2af6c68f8b0d96f25574446e142c3eb0d9a4"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "30108806277b639f8b7b9463eb73638b15ad0b885890afbb8c5353ab68eb4272"
    sha256 cellar: :any,                 arm64_sonoma:   "2e14df738f00604bcc6f5bd534dc4a6216486240427aa007b5fe8df7b187b0fd"
    sha256 cellar: :any,                 arm64_ventura:  "ca997e18666ae5d5a8e5763e33734b275cefe959a8f2e255d6851eb8f301978f"
    sha256 cellar: :any,                 arm64_monterey: "f0a77287617143cdfa16431336601bf3a6f8a0414361b0b67b4516fc738f3c81"
    sha256 cellar: :any,                 sonoma:         "b30608d83869c763c51775791e1d005d644c72cc64f2fa9d15c8cd2b11e77d39"
    sha256 cellar: :any,                 ventura:        "c821b2f2fe7931a46ab12c76675d3ffb7dd6b52e867ea760043c5c3b0f3487c7"
    sha256 cellar: :any,                 monterey:       "8c6b64e84a4345a3825af63c61b0e3240d5c3de2650cfbe7c3845d0a968eb4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94edf173dbacdba66a99216f910de374584c51a6a59ea97695ca251024a61a10"
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
