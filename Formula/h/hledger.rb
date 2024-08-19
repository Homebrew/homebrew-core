class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.34.tar.gz"
  sha256 "e3548b2a2944142ff45e8ca02649ee450f228a4c0964e153399128f7c4dc2781"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f85662f27d3d42f5632e7123de13af80be9d695c43222d996afb5cd7f70a8660"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb077867ef712d618b34d4f2dee5e37888c3571d342fde30839697c8d7b48c47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ba390b870b47c36ed274d31a66d49d40f368590f300c18475c444874010890c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ecb2f53dba2b10f31b23f231f9958ddbc7fcad54827fecddbcb2fac18104f00"
    sha256 cellar: :any_skip_relocation, ventura:        "d5cc44563c993c2629c9aa7a7932d37a198edf6bf87a813ce3616e3ca17233dc"
    sha256 cellar: :any_skip_relocation, monterey:       "bb6e8532ee895abff717bae723b02c480c6318b698ea95dafc6550db1d3e59f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9ded63b6a2acf3e0a083a4c75957af2d70cbcbeefc9f9a54522b0bb9e7a0eb3"
  end

  depends_on "ghc@9.8" => :build
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
