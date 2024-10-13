class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.40.tar.gz"
  sha256 "fac19b524566b08ff0ade9793e8440ed0d31ab7bf7c5a33ac73c21ec05f358aa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "743ffb01ef98164adc24d38bf7d7157a8c28443da32c28d4ab737fd7332ac996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c33f69d843a135a0f3df5496ad5ddfea395be6e4324dc8d81cada61c952722f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c60c65d440480d6e8e0283d8de3c86f007a1a440d9ac947e1e03236d246b530a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "727a907e5447c55e5f88fa0e2aaba0b0c8deccba402cd8dfdcdc1e7d96fd4165"
    sha256 cellar: :any_skip_relocation, sonoma:         "80cf62d4bdff770e20c42a38ed009e978c882dcfaeb8a91b8f97c3249c15a574"
    sha256 cellar: :any_skip_relocation, ventura:        "a95911dff60f8a30b0a8e8c19e24ae8efad7f59fb42cfe4d0ffb78d864694808"
    sha256 cellar: :any_skip_relocation, monterey:       "2af6d01f2c109bde9a191247001f16137c63df669f97b91b24d05417981de54f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb47392110629bc44148f6bb68a6a104dc671f11ff0fe7efa91a3c84d7259dc"
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
