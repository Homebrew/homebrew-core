class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.51.2.tar.gz"
  sha256 "0523c5b0a2014459364a997ad74aa8cad1a78d847c3ede6232d19636207aee48"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e9e4a48a878f750c0c07ccc78dd0a69f45c487fc2cced59f2d994eaef667ed95"
    sha256 cellar: :any,                 arm64_sequoia: "5adceee6935800db30e43c4d18f7d17a4756edf3863f97becd4a79143e3ff325"
    sha256 cellar: :any,                 arm64_sonoma:  "cbc43c16daf43e39ce3d3cc697edea5a8bb61bd0ca18a45561bb03d716ac1a40"
    sha256 cellar: :any,                 sonoma:        "6d0291a8eb31bc0cbad40e07ad635058537cb68ea08d68645013dcb0bf411c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45868c81b64a86a9ff5145f1c65a80c17c1c4bf2f2f27cad99589dac947e6f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83d020d0f12549ba2caa4a6f076b201acf3cc6c4ae046fde1f68661d0433d29"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
