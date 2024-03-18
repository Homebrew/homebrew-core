class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.0e.tar.gz"
  version "0.3.17.0e"
  sha256 "27344f6e2c463ac4c9df6c3c5820e20daa8ae8d8351344bd91beb4aaa9e7c931"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21c84225580dc02889ea17f9479b01db391670b031d84fd3f8b13eb7768a49eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a377448e3dfc6f3740cd609b69d45e074230f02fb4859c8b301bc0bea8626e8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbc6aa9b3cf63659ae9a958e6263b2da8095fbf4dbddc9be28e5eabe4a6d228d"
    sha256 cellar: :any_skip_relocation, sonoma:         "603299ffca0fbdcc17162826001511e1a6115e5bddf1ef2fea36677f7328b006"
    sha256 cellar: :any_skip_relocation, ventura:        "3ae8a2e72518d5dc7dd116ec12dcdbd95575cc4629d9a3a9ace488d9933a7cdf"
    sha256 cellar: :any_skip_relocation, monterey:       "d4b1f9e019dbb582ea569c71d7c98ca366d98a46b06a3573f5ddd51ce775019d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89065c0766d3c23c39a8ae1c03d370e6226055ffdb57401589c1e6a60e75bfb5"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm_f "cabal.project.freeze"

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
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
