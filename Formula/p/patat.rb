class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https://github.com/jaspervdj/patat"
  url "https://hackage.haskell.org/package/patat-0.12.0.0/patat-0.12.0.0.tar.gz"
  sha256 "5b93df3ee9f730655a7b93abf5148aaf576d10fd8409e76e5443054f861b2029"
  license "GPL-2.0-or-later"
  head "https://github.com/jaspervdj/patat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d70af90d558c895c512cb672797a730cef1243d84c4e9bc5c00d5e3e41309dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8321387e99f956f1519463b135fd07994e8d062357e8c03475e85bb6e555191d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f966c64de45ee6b9fe64546b3e13953c2333aa015b7495facd8d6c34fb489493"
    sha256 cellar: :any_skip_relocation, sonoma:         "2746e29750e1cf33e4b4a42761a20892137c0bd33475bea6ce9bb30326cabbd5"
    sha256 cellar: :any_skip_relocation, ventura:        "2f9de7b6c0df90b8295a3c122afc4e7288e5a5cd8bb32e9a4df6a4d8ad3d657f"
    sha256 cellar: :any_skip_relocation, monterey:       "733ce8ec1321be118513223dd3851b2de9a1feeae4c88725ee1f6e0b58510d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62f2b0f018eaf92e75b5eafa130ff43d7cb833105a92f6fbaa308f09213e4393"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    test_file = testpath/"test.md"
    test_file.write <<~EOS
      # Hello from Patat
      Slide 1
      ---
      Slide 2
    EOS
    output = shell_output("#{bin}/patat --dump --force #{test_file}")
    assert_match "Hello from Patat", output

    assert_match version.to_s, shell_output("#{bin}/patat --version")
  end
end
