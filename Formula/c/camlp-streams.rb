class CamlpStreams < Formula
  desc "Stream and Genlex libraries for use with Camlp4 and Camlp5"
  homepage "https://github.com/ocaml/camlp-streams"
  url "https://github.com/ocaml/camlp-streams/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "ad71f62406e9bb4e7fb5d4593ede2af6c68f8b0d96f25574446e142c3eb0d9a4"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 7

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2cd65050a328163edca6dd9c3fb3ccc5094e4bd561c31f5ed0e6fb1ffd88f7d2"
    sha256 cellar: :any, arm64_sequoia: "82fa83efcbf4f9397061dfabd4e57d6ada3bc26b003921e48add52fa8d3bbc38"
    sha256 cellar: :any, arm64_sonoma:  "6c10f0fc8aca899c600015b713ed1ed0d00c46007541b67a031e4ce0c4d611f7"
    sha256 cellar: :any, sonoma:        "c3f63dd0a75b359ef4f326290b8a1960a2adb80d7916c3cc5042509aef751a9b"
    sha256 cellar: :any, arm64_linux:   "3539edb75c2d27ad89d8c31c5795cf602458f95e20851774fd7868f0883da6d1"
    sha256 cellar: :any, x86_64_linux:  "c6d3b6df0e554f0b2595b4138a048c5040cab9903f6af0407caff06f58bd6cbb"
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
