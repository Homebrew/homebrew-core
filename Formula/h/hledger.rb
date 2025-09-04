class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.50.tar.gz"
  sha256 "2a4c4f13c5f46ff9dd3e5465103fe032891387e914b49608fbf45d1dc74f4cfb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c18f4f5f8e180151ab84eaeb262b678c2977d3464524e416377863035836ee8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8068dd95c7314da3b1de914e06f806156f01b34fc8913d1215238316bfff4d9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "347d8316c18449aa8561c39163ee9721de574d777fe0e8cab2cd456a7b510b88"
    sha256 cellar: :any_skip_relocation, sonoma:        "85721acd3f1e13d40d96c477efd4ad9920a604c3504f50155dd9644afd513a1e"
    sha256 cellar: :any_skip_relocation, ventura:       "29f6d4cbb3c7410c949f1f7c0a2ca489cb4f95a4555cb524faf197b5f00a3c8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85ef2e89653e777bf03c18c8c5c96b3f9a625e1b0b59a08a668dd19c08dd7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35e546a33c87fac2357033d687e079542b3b4766dcf1531312474e83934256e9"
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
