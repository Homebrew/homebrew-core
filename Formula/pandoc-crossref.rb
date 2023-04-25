class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/v0.3.15.2a.tar.gz"
  version "0.3.15.2a"
  sha256 "1abce983628bbb244e976e3ecb8d1ba0d1de602767c5a919ccb1fd9fd3140b74"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0983cc7406cbeb627f6e7cc6a0ed395921c44afd35adf47b15eb0650cca809c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8adc097fed7b8787c84275756da6018cff75e9401e7ecdff4f6f883d094debde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f77621d2e47082042359ec9b86a68312a3243bb73671a039eb359e0f1407d67"
    sha256 cellar: :any_skip_relocation, ventura:        "223cce417bb834a8444cf2bbbba5f8d9d4778631ee2e4011e16c913cd5fc4932"
    sha256 cellar: :any_skip_relocation, monterey:       "51c4318cef79b132840a52788b69942264c53edbf73ada41c2c15a467541ed3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "143f0d02e0eff2b27686d09c76c20c6d5245234069147c65e62f7190ff9450ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a11a7bd644fee676d663958f581e6e60dddbb173d0fc4502e4cb603c907ad6e"
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
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
