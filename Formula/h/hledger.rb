class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.50.3.tar.gz"
  sha256 "fcc6e26e1dd53bf747723c2d54f53fbbc8d5ab78a1393b21948616c7615a5703"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac75f3968420b018a1c75a790639bfa26eb2e8db58f7dbe51d6287938e828cdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d4ea514d6c01ced368416ee28a33ac2a6d071d253b5a8a749339fb7a8121503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a314bc545860d483a37826974de74afd858aa14d439b25b4a5ac04dd86f804a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "32399f1d1f08efe37dd3563bc21088470aced684915fd54d0096fde10d3253ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "707ccc92fce0618b673be5712fa3a6f67398fd952e22d9547519b8e02446303a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34424c16438cc0e8700c457b5f3937c651d73cb2900819fc8b56edd3225ac7c"
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
