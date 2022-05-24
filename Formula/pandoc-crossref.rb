class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.12.2/pandoc-crossref-0.3.12.2.tar.gz"
  sha256 "94540325c9c98ae4d5199c634bf402ffa41e3c5b020d7207daef90fd9e224fb4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "576649f2e937c1231d0af6909e92153808471b19463691c7b38f3ccd1927dca0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfd697182b040325c1bceb049a5121faa05f4143eabb5c879b7a2e95459d8033"
    sha256 cellar: :any_skip_relocation, monterey:       "ca887409b851f6167f4f4304ee12d718b5b41a7b3291fab011e4a6e723bf8afa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4109269adeb80e636a428c04c0ee016103820df84147b543d6221e56b8587c8b"
    sha256 cellar: :any_skip_relocation, catalina:       "f77c6a8d5ad38bef3d24cd3ef8fabf9bc18b1c3ff82e4d54b0850eabf37780e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f587334df22fa23eeb001dabb50852dc23669be7ff71e2b4159a632cabe204e1"
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
