class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.41.tar.gz"
  sha256 "627db83f148ea3c339cabd9aa9e4ab42d372ef56ab837e5d5539c75f8a82a30d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4582cbc364d5ba4e13d2d0aa6e30e09a085b3c3922b0cd4188772be080f7156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04c8a0e49f67695e2719d5c0188d6e40e9e31a81b74cd7284998f644a1c08beb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93b4c915312a226e4c34ca7e91d2e03c27bf502ef93a1516b1b5ecc6c0de1102"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b888de72cd2f65abcc3c46d5216f2e80a519e08015a40322dff8b5e4a0f9fbc"
    sha256 cellar: :any_skip_relocation, ventura:       "84c13d7ab6cfe65cee349cb595956d366bbed3ae748e548b7aed042b69e7c518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e06fa5f1bde15cf47f2671f6b5012731476dee82e05d79aa09ec383c44b3a95"
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
