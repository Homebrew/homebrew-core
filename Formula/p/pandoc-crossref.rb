class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.17.0e.tar.gz"
  version "0.3.17.0e"
  sha256 "27344f6e2c463ac4c9df6c3c5820e20daa8ae8d8351344bd91beb4aaa9e7c931"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f25f89d9950959fbd596fe05a228de59690ec6af6d4a5ae3d451840ed07cf13d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e56d90dbed1b4c018da76dec74e5e5d248f1df75d6e91accced5849127498c0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "258b8f2eeb6e36e911877a1a26f152d2c3b991727381c4ff36fb5ec51b957393"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac644f9a42c3590d63ed311d6bc1c1daca1232e45eab91d22bfff682e3570ebd"
    sha256 cellar: :any_skip_relocation, ventura:        "415199e4c3e2732b3a3d450a74f7a3bdfc03301bacd1654941a2e60f11213745"
    sha256 cellar: :any_skip_relocation, monterey:       "c5956bdfd8ac9833e918173ac099a74dd2430d570b672d767097014ec2e29eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b5160fa2f717819ea51df4db4edbc1938b10b1ce0bd3e25cafda8eb4214209d"
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
