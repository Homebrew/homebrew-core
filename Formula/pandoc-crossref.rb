class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.14.0/pandoc-crossref-0.3.14.0.tar.gz"
  sha256 "06d163e2cec3f285919295c41a0580f203bb157d05eb06a494dbc093cbefa5b8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e00c40054f006b3ecfe770f9eebbdfeb77f2a1e0fd196ce7944a5590b9d5dad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce92d247d67c3b6af83ac82391326d907f7c651126293890c9f5eaf9263c407f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8d0e28f1eeceef6a0af886375edef8fbf8a12cbebaad7be0dbc05f2d077a615"
    sha256 cellar: :any_skip_relocation, ventura:        "1c14f8ece74af959f41473c4f4999964929e5db9e5e9db542fde6b61bec7322f"
    sha256 cellar: :any_skip_relocation, monterey:       "c8e27c688e893217777296e03419a80f6906c4c6d87ef020a81dc08b9e3cec6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "92f9230439a5271c09c022cc6b3e18f65b9508b1be2bc3f50bd7ec8edf577ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "840a2ce2a3865f12a6f59a755a2778922f8c20f053c9774f32d5d8f336cc39b1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-crossref", "-o", "out.html", "hello.md"
    assert_match "∑", (testpath/"out.html").read
  end
end
