class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.29.1.tar.gz"
  sha256 "3dab4557d0c25ff05ef62f33e5f13b8c13f4060c370530997a379b3096ecdb67"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efed098da42159c41d596a0ddd8d02271555075a86ccf68a36b1a25a75a5f1db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fb179d4c0f29f0cb14056c7e0536ad317d35caed3c4af6ea511d934cc0402a8"
    sha256 cellar: :any_skip_relocation, ventura:        "d7454dc9e624d9517e52fed7356a8d771cefe30f826a5afce8e0965ca69b20ea"
    sha256 cellar: :any_skip_relocation, monterey:       "eb462317421cd1b6b377ba982c387e270ae67a5eca0c1f9c1a3a7c7aa44c972d"
    sha256 cellar: :any_skip_relocation, big_sur:        "83a8b202e2a6b6f0b32c81b62aed9f2830aa584f87c44c404519a617b4de76d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66cc52f1164084aeaf3f2bf28d6e50bf1e58c1dbf0c6ccfa02a2f505a7b01adf"
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
