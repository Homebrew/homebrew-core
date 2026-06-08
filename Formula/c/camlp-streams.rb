class CamlpStreams < Formula
  desc "Stream and Genlex libraries for use with Camlp4 and Camlp5"
  homepage "https://github.com/ocaml/camlp-streams"
  url "https://github.com/ocaml/camlp-streams/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "ad71f62406e9bb4e7fb5d4593ede2af6c68f8b0d96f25574446e142c3eb0d9a4"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76394abee9ae7ef19a15ab56903b9464bbfdb87b41190971771c4434dcc93e47"
    sha256 cellar: :any,                 arm64_sequoia: "af06355d22d11b04eb464579829aa50b85f731966bc624e1518307e190259e16"
    sha256 cellar: :any,                 arm64_sonoma:  "610058986c20012b42f12681aa6960f0ab73c91bb29a773ec671793eabf371c9"
    sha256 cellar: :any,                 sonoma:        "c9d510f707c518f3722cdea9e5a94b3807adf87185cac0e4a522c5abcde6c949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "488c452c708981035a8158417c2b451228f0d2cf5119a1d3a86ef918d8a65674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15081fcdb9677e8cd2f645899eed800d8e7ce5d0f379fd6e286b3026075b0175"
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
    assert_path_exists testpath/"test"
  end
end
