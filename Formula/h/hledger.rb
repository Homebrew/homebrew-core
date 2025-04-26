class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.42.1.tar.gz"
  sha256 "4f1f51b3a9881f8916ee560ef6d59256e4a7b3dc41805a5cb72d9e32e9a3609d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f5ab7f6bab85b88efaf347acef94c022b3641c2693571b43edc55cc1fcea88e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7f9ad75611a7c7a1e679936aebc6a102bf486de208220f32fb83793bdf2b43a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf2be7014cae8f431a444f602c87140f53f84442f50f091c062fb42220454f59"
    sha256 cellar: :any_skip_relocation, sonoma:        "63f0dc6e1350138fbd4dc87d834e8e34541a6571af225c3f31046a2f996193e7"
    sha256 cellar: :any_skip_relocation, ventura:       "7ce2d500f72423d8916c557d0eac3c484b4b43d29e0c83577e877381c35e1829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ac5ecf1f2e73dbff32e466330c31c9622d81acc1b913cee21fd5885581ca754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dedee0b7c5e25ae0af2417c5594e11efd59c919856dc74dbcb3865b799eb7647"
  end

  depends_on "ghc@9.10" => :build
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
