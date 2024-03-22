class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.32.3.tar.gz"
  sha256 "92b6818302532d31ad1c915157d180186b3ffbc09f5a17484423e784f0209d14"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "496f91ff5ef16d1fbfae98d0369f6363631da2eb5c0e165b240d46d6a5f65d63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7262df9e64ff01ce5fcc639d132ef0a13e4465219db7ee4ab8f91a33f125b781"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e30857e98674787298fdf45849e39a01387a7e0d6948c5909f08e6316cf8d814"
    sha256 cellar: :any_skip_relocation, sonoma:         "514f0670b3a5d724a6943e856a4e9edabf1b1e6ca3698391fc93ce70a10e2b9f"
    sha256 cellar: :any_skip_relocation, ventura:        "1ddee10327031f26db964d86d344be95d47f080fd5fe04d133130a767c09f7da"
    sha256 cellar: :any_skip_relocation, monterey:       "9883fe5f9b63d3f2db6b25972e7a74049133ecb836eae38c7fb243d357757ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f509b19fac7f5a556b0240efb50590bbeef0a04d75a379be2960b8b7bdaef80"
  end

  depends_on "ghc@9.6" => :build
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
