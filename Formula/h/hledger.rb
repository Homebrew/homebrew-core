class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.50.1.tar.gz"
  sha256 "6e94e12f5cf58886af476f9f3a813ddd407049d1f6aefe98810b798a17562177"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b945e2c269d4303d09f85f3287e58ee913f6d03f018ef225a3cbf696096b5d6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42254df6148820c370b4c69191946d2fbd9472b59e0e37b55863c1f6f0b8e2d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7799dff7ae5119d356503c1591901f9f790d402093ea89ae7df1219eadd2a07c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9809a5b7b01973228e6df6d2b9b5785e5ec10b47cc7e786f92be93b07e43a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a51bc1131f95b05de3c17c40ace2368127ffa4b4bcbdc4d1d3eebe9309d9a30"
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
