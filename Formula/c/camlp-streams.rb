class CamlpStreams < Formula
  desc "Stream and Genlex libraries for use with Camlp4 and Camlp5"
  homepage "https://github.com/ocaml/camlp-streams"
  url "https://github.com/ocaml/camlp-streams/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "ad71f62406e9bb4e7fb5d4593ede2af6c68f8b0d96f25574446e142c3eb0d9a4"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a024fcd64fbed528d969bd51a27452741c1822b7f2946ece9c9b68c2d784e8ff"
    sha256 cellar: :any,                 arm64_sequoia: "970fd620e3640135d45f61c7844b988f5a09dde94168f8649a8ec7f9e6f4a2cf"
    sha256 cellar: :any,                 arm64_sonoma:  "1f73dac23e1b752a50fe5f3f68a6397c4a0cd7c350852451e5700c7806e00e71"
    sha256 cellar: :any,                 arm64_ventura: "0a886bbea94a7e4d0540630b51923b68398a01ae609dd1193a251857567033fe"
    sha256 cellar: :any,                 sonoma:        "38329d0763fc0c96171a6ac720b2bdc1cb88f66d2fff5422120cc54624123ec2"
    sha256 cellar: :any,                 ventura:       "f4ee40b44bb00867dc0b570a71469bcf6e5f2024a32512747cddd2c5b29ff8e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "931af370b98b65b36f884ed1cb981cd88cb078bee5dac2be0dab438dd27eab07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "037b83a383c536e2c9c5303ead944d3e4439bfaeba3d5d9f21f6165ca82bf1ed"
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
