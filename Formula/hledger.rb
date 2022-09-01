class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.26.1/hledger-1.26.1.tar.gz"
  sha256 "245af2ec616a754fb488a7ad8ffa360732b733d96c7d6b1e49d4b0fbd435e247"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c2c3ef744bf7a4068401082afcc7f516b95b04fefa5f112dd52c84316cf884d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42674338ee571f5596b600908a765aec0911ff737de12ba9842bbfd6523a5060"
    sha256 cellar: :any_skip_relocation, monterey:       "3b37e97b8c963a64fa459fc3b89b5dc989e9b7ae4d1e4a89ce48cdd9b560a6e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf6fd65c4fc31e0a048c285ac9186b265febdfb8ecbe3ad726d9d611743f5384"
    sha256 cellar: :any_skip_relocation, catalina:       "8830b28f1ad6b581e5d0093dd79226c4f01a8c42c922d16aacdbaafc990528de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c5cedfe3a02b5bc598c33a64d89b947e769c0c48ce2df7c9709c9311f22fb9"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.26.1/hledger-lib-1.26.1.tar.gz"
    sha256 "2c9ef04c2cda669e2b83b8d2d8512f5a298cd95e5f9e825e697204ba96c85da5"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.26.1/hledger-ui-1.26.1.tar.gz"
    sha256 "8bdeea8383201328e85d49be823787fe7ea1daf811189a41d3d4ce8d98d47e3d"
  end

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.26.1/hledger-web-1.26.1.tar.gz"
    sha256 "e2b0d21c6657a234d4f991439dfbbf511490c8eae09bf832c824c272c7d0e6c7"
  end

  def install
    (buildpath/"../hledger-lib").install resource("hledger-lib")
    (buildpath/"../hledger-ui").install resource("hledger-ui")
    (buildpath/"../hledger-web").install resource("hledger-web")
    cd ".." do
      system "stack", "update"
      (buildpath/"../stack.yaml").write <<~EOS
        resolver: lts-17.5
        compiler: ghc-#{Formula["ghc"].version}
        compiler-check: newer-minor
        packages:
        - hledger-#{version}
        - hledger-lib
        - hledger-ui
        - hledger-web
      EOS
      system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"

      man1.install Dir["hledger-*/*.1"]
      man5.install Dir["hledger-lib/*.5"]
      info.install Dir["hledger-*/*.info"]
    end
  end

  test do
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-ui", "--version"
    system "#{bin}/hledger-web", "--test"
  end
end
