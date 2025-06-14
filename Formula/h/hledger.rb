class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.43.2.tar.gz"
  sha256 "60b74c70ddfc6b84ca87debd2ac302aac754da3c0d9089821182e56796cb841e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b6e3bcce3266ea10bd6f1522525a9910c201236b6bea00b7b8d09d2681587cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "208bc36c3a713c4fb036b809023f7eefae3738730b7f8c499b8a3480dea1a469"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8fb2c0cf9dba252e438fa26641c6a1edfa86f54c362b98f315f24e73923286b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5189ae1e362f0a81d3e0fb156b70e005ef2254c1fbeb2beb1dbeafde971e2ca2"
    sha256 cellar: :any_skip_relocation, ventura:       "1ca5a6647c6c594c04598c8d51f61f675fc00b0adf348ba7dd997b1a9965dd45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f53d2089b27417568385d2c453d039e964bc674d280e236cd45026eeb2a43678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f0f602de7fd5edf198b5bdf7010c9a284a3200fc8d69968f9e594adc1460d1"
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
