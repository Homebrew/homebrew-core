class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https://github.com/jaspervdj/patat"
  url "https://hackage.haskell.org/package/patat-0.11.0.0/patat-0.11.0.0.tar.gz"
  sha256 "34f1f5ca565be76e0a75920290b7c8552132822f1d4a7ab85d445bc13c7c6ec6"
  license "GPL-2.0-or-later"
  head "https://github.com/jaspervdj/patat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a86c86cbd28b7741233b5cb22a981ad34d3e29c882be84c2986d7f1401867f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bcb4bb432e226fa141159e07ab90b6c7901832654551af6916b40e4d0c87504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "986afaf1b32a36f10820571d17f3a7013060638e9769abc0e31551672374b54f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a6c1735507166c51bf5cd5669e379beca3252cb2a68d5e03ab5b0c94dc165d2"
    sha256 cellar: :any_skip_relocation, ventura:        "f17abaf21b7295d8086f06ccf13e06773987bf810b6f4f4a3c652ffb258bdaa8"
    sha256 cellar: :any_skip_relocation, monterey:       "3f54242789cf3a582781408a5f77d0a7e0d4beee9cf3955b3b452806dc19f101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b2ad5d98169a20186e7a4a5393055c916d741241c4369b789fc493688e97263"
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
