class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.42.tar.gz"
  sha256 "cd7009ca46ac1fac29cc90322502c3cfd5f4ad92e6ac15b589b62a2b3460a1ba"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76955c6093c13ba4907a9d9998b9182f81fef51ea85f618fb435c44708461a0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a9d40aaada55dc8157474f3e03cb216269f7ea7af50679022c85746c1676f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5e5d8a7e79d066fd46b40b0f35f8b3f5b474dffe6036d7edddbf8f22c30e5c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "adb42cec17e181ce829386107ccf73371f6b1839b0137735d561ed84bd700e87"
    sha256 cellar: :any_skip_relocation, ventura:       "5cfb3c0e6b688dddf238cb73d2b41b6fecd4845e3ca70835050622b6630b101e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f308b5eea619561d1ac92ca773a1945405635040f70ebf2b022171ba8ffbadc"
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
