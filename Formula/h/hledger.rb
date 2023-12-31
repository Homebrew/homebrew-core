class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.32.1.tar.gz"
  sha256 "73f54d82766480c8c8075552df8b5ccc7f449ee00fc710ccde51393a0317e995"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a45dba83171691eaa8f34f19eaebba235370aa89889ce72b4a7817cd321e593"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "decb859c81e3eee4b0c87aad75ad4056e7a01f0219f046dfc8ba65eb9f953b00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1366af9ac0666e7259a5932eed1a58dc5e38a81ff30aad269ff68e3db6367a04"
    sha256 cellar: :any_skip_relocation, sonoma:         "5288853d71c50037a8d098f642ec7424281f68da34d7106d336f175965ca7ea1"
    sha256 cellar: :any_skip_relocation, ventura:        "de5354dae53da583060cde5ce58301a042da507e1ddcb252f9b2a1433d4561ba"
    sha256 cellar: :any_skip_relocation, monterey:       "a0511729061f94f66bd9b2d6f649d49842b140f1cde068dbcd98d62278d86f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fab8c1d87dcd1e4ce0f78ac070db5869f618df57f0c8f0da71a12185287e266"
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
