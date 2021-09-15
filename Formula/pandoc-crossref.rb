class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.12.0/pandoc-crossref-0.3.12.0.tar.gz"
  sha256 "5f1fc6a1755488477448f4df82869b05f3cf21f7d2f0b08ef951be652e0d2979"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b525d5593fc8e35259c94fe0352ac89ae51564d2681a69e08e66915f8c0dd7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "777c6def219f6ce20fc702ff5b9da4cf404c083b4376947c46a98da6cfeae046"
    sha256 cellar: :any_skip_relocation, catalina:      "57d4c7b20861051984b105ffce52e3e7716ddd3484dd34b2068da1851ad35547"
    sha256 cellar: :any_skip_relocation, mojave:        "f5b01586f853381399a67e203a95e404184916cc6fe81edc5c3a0844b6762337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae4f8dbc8a165ebc5adb838c4fe21acd1d674fa8b614837962c200aa93bbd027"
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
