class CamlpStreams < Formula
  desc "Stream and Genlex libraries for use with Camlp4 and Camlp5"
  homepage "https://github.com/ocaml/camlp-streams"
  url "https://github.com/ocaml/camlp-streams/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "ad71f62406e9bb4e7fb5d4593ede2af6c68f8b0d96f25574446e142c3eb0d9a4"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9c01e19dbc10f3a4af763dc523057b9d9ed8a228bfe112f95750b9c8b3bfc2e4"
    sha256 cellar: :any,                 arm64_sonoma:  "8c5b166642bda73a4b0cec82e26841cf04037cb1b95c491e2a38d32e3655e823"
    sha256 cellar: :any,                 arm64_ventura: "6e875ba06b206710fb758931b43acb200e772281009d97c04958a146da7279ec"
    sha256 cellar: :any,                 sonoma:        "84d5d716b9e0f96a7089aa19016f73ed7bbac5d57c5d1021ab60651bd59f565c"
    sha256 cellar: :any,                 ventura:       "9d289d1670bedb77b8584e5c4415aee97d234d3ae68be690e716919c4205bd28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73528fbe83c95610b483969a7e22cd21591a66d65db021c9029e0a1d60adc615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad5e7c5397bb03af1cc538b43fda7e20169c35e1ff987489253aeb012ad8497b"
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
