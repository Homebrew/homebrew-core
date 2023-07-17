class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.12/dhall-yaml-1.2.12.tar.gz"
  sha256 "e288091b568cfba756eb458716fb84745eb2599a848326b3eb3b45a5aa0008ea"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60918942c74cf83abd706490eeec2f2816091d056e3f82f24e290aafdaef86db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe775dc7d1bceb1092432a18c77a7ff73ec6a88fd746cff10e3ae68fd83cf1bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a36c8233e6daf8bbe69ef15e1a912c434c3d23d29d30aeab8baf5e94e8180f6"
    sha256 cellar: :any_skip_relocation, ventura:        "2df9ca5ea3a7f380ec1a2fd81774dba3e6de660f04ea71e087d6802db5e3e698"
    sha256 cellar: :any_skip_relocation, monterey:       "a6de38223fd4b46307b47921221e17ae595cf0c373754e5c2581748577bd60a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "888829d746d06aab61352b934b2f052a4834e96fa19f6243a7321cb3aa8ea5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81991d8903d4c9c9b2f5e8513013f3c972c0e805ff3030a46b6a75617487cb4f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-yaml-ng", "1", 0)
    assert_match "- 1\n- 2", pipe_output("#{bin}/dhall-to-yaml-ng", "[ 1, 2 ]", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-yaml-ng", "None Natural", 0)
  end
end
