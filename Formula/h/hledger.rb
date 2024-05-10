class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.33.1.tar.gz"
  sha256 "47c6a1dbcc74a89c0b820745bbdfb247d26040104bc2fbfe4f03f11ecaf7de30"
  license "GPL-3.0-or-later"
  head "https://github.com/simonmichael/hledger.git", branch: "master"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e47936cea3a1bc5ac65bd5652589dc18b2637d4bb7b47424eeb572e9ebfeea4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4afa727c2bd64ef2d2c7b5c4e74e22fdfc7e474837d213a41f328c8c796bd930"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fae4956fdcf9ed15b2dcea6c84884eb0c5a381cd2b8c842e7405f062baf96e81"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e5aaa4e293ce742edd5c2969917678118d543abc360fc646e68a60c0e603fb8"
    sha256 cellar: :any_skip_relocation, ventura:        "0ce6839041cef4bd1cf4d3c91d0ea8a0e5807ddadaf6f2a1abd8d083dd1efdac"
    sha256 cellar: :any_skip_relocation, monterey:       "692f16b655efeca6869891161c80051674da3b30de8851516ec7a82962bb5485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "935f9ebfe2ce7b1d1fa684e2030a4eb211a2739846d51c34b5813d8d1a3877b5"
  end

  depends_on "ghc@9.6" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "stack", "update"
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
    man1.install Dir["hledger*/*.1"]
    info.install Dir["hledger*/*.info"]
    bash_completion.install "hledger/shell-completion/hledger-completion.bash" => "hledger"
  end

  test do
    system bin/"hledger", "test"
    system bin/"hledger-ui", "--version"
    system bin/"hledger-web", "--test"
  end
end
