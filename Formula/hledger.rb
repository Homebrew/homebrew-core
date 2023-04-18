class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.29.2.tar.gz"
  sha256 "9172e8cd4780a1157d18d6cbc5cd765b1b8f873f167dc4033f2c042a778bef45"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a529847091cae975547ec712729c2bd300b5e2c13a301387f69f7b1051665190"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8c08780312b4db3d92d22be49c70219487fb4e5bc765c1391e95c6436236d02"
    sha256 cellar: :any_skip_relocation, ventura:        "57a01f8ef1504d300e9b710bfb4d7360b181ef27d331a7ec3ab4f60cbcb019d5"
    sha256 cellar: :any_skip_relocation, monterey:       "6e4afd87eb083afcdb99bf31e4016967b2ffa31cb93d4316b80284ae8569e170"
    sha256 cellar: :any_skip_relocation, big_sur:        "a205930832d266d6a80dfb014e5386687eb6b2a8d5c685866b84822582ced358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8982ef44832bd18545bd093ba4fd59a2f771572b84e0e42a87082041a183b45"
  end

  depends_on "ghc@9.2" => :build
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
