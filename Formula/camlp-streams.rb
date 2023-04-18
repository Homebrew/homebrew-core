class CamlpStreams < Formula
  desc "Stream and Genlex libraries for use with Camlp4 and Camlp5"
  homepage "https://github.com/ocaml/camlp-streams"
  url "https://github.com/ocaml/camlp-streams/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "ad71f62406e9bb4e7fb5d4593ede2af6c68f8b0d96f25574446e142c3eb0d9a4"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "71fce4c1acb3764add19c7bc62932779d6eba6bd5a71c5eb0da1f1d94631f58f"
    sha256 cellar: :any,                 arm64_monterey: "1aa419c01a3ca2738adf10d613def4cb213efea7c7af7682246287ef5a96a09a"
    sha256 cellar: :any,                 arm64_big_sur:  "551ca86de9bdb769f0f22de773eb4a93f9faf31193f6b8833e39d30efe15fa03"
    sha256 cellar: :any,                 ventura:        "0a47174a14ce39c3f2c3b1528a01365a2fd3269533f0eb7b6605faf698fb7545"
    sha256 cellar: :any,                 monterey:       "f4fd0d6a51abb24f93fea4e7326dce470808aa5d6f2a8aca2750cd4bc9987174"
    sha256 cellar: :any,                 big_sur:        "ee7ac1eda08673f956c10805187f58271fc1867522d93c004ebdbc085ca822af"
    sha256 cellar: :any,                 catalina:       "0ef92902025844dd1abbe5fdc3f3c8e114b090738e6022f68d72c21aa608b9d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e1d03158ed662d6266ae792dcb9145c042c61c0d3bd2b0e1079f8e42d6c72b"
  end

  depends_on "dune" => :build
  depends_on "ocaml-findlib" => :test
  depends_on "ocaml"

  def install
    system "dune", "build", "@install"
    system "dune", "install", "--prefix=#{prefix}", "--libdir=#{lib}/ocaml", "--docdir=#{doc.parent}"
  end

  test do
    (testpath/"test.ml").write <<~EOS
      let stream = Stream.of_list ([] : unit list)
    EOS
    system "ocamlfind", "ocamlopt", "-linkpkg", "-package", "camlp-streams",
                                    "-warn-error", "+3", "-o", "test", "test.ml"
    assert_predicate testpath/"test", :exist?
  end
end
