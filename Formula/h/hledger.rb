class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.31.tar.gz"
  sha256 "d846d51a0144c10f78a692ce2bb665247600514214393b43498d37701f197264"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea9e3e381fd70099457677f796af98778042b69386fadcfe1084c253d03b8c03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0046566f35f74647d2876fafa231047edc507f9406a6214f9335c4a638907e3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baac4f3451a6478e1961583e92a32bf897adb49dc9bd3692d68205c107e20402"
    sha256 cellar: :any_skip_relocation, ventura:        "3eb325f2a5e15722199b2d97a409bca26dc09a3df09a28c2957faf33d53b9221"
    sha256 cellar: :any_skip_relocation, monterey:       "d1afda910d9c5800553111a45c2fc5e2a36c936c8de097d48da08bc46664f06d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf26f49ca56472688bb138691711ffc44c9022cb279346737c2a5998506a06b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb7e74a60da217f73d77779dfbcaf814f06d019b75cb8f0b0eaf4d107723402b"
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
