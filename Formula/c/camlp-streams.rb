class CamlpStreams < Formula
  desc "Stream and Genlex libraries for use with Camlp4 and Camlp5"
  homepage "https://github.com/ocaml/camlp-streams"
  url "https://github.com/ocaml/camlp-streams/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "ad71f62406e9bb4e7fb5d4593ede2af6c68f8b0d96f25574446e142c3eb0d9a4"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  revision 5

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7fe4bfbf60135b74ed63cd5430c8aaa06afc4b6755562448b43061c33dc92bb"
    sha256 cellar: :any,                 arm64_sequoia: "bb52bd02f32203ab2afd5ba95e31870d7a1434958b1c738a05d9b74d4d5d8117"
    sha256 cellar: :any,                 arm64_sonoma:  "367be637dbd5fb4baadb86f92ca0c6758d896f78fae0ae48beb93be26004fcf3"
    sha256 cellar: :any,                 sonoma:        "9b129d7d4072cf67c52b0ae723390101a5790799788d34d9a169111c52220325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c6078a8ea7c69644008875bd7f8a77025cd725f0ad98038136fe39c27536533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fb3cdc0726e6a68db04b269e89f5e3e6754bbbbf2ac102628f19edb9f8dda3a"
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
