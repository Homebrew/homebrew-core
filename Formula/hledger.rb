class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.21/hledger-1.21.tar.gz"
  sha256 "5a57b05b3b934c781a6bb443611236e92b0ba03c0c0b67a515c933b2eb74cc1d"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/download.html"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "83d91bd5847275c6e7089b71332015c71272bc24f562a55b595e8c192bfe7285"
    sha256 cellar: :any_skip_relocation, catalina: "5f812bbfa7a4409166716730edf3fda92bb6a6dcb99572440d926a56e47554b2"
    sha256 cellar: :any_skip_relocation, mojave:   "0a379919ad9936b1b93b7af1103fd5c98656c43ed879eea8f2e0dcfdcccb2e0a"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "llvm" => :build if Hardware::CPU.arm?

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.21/hledger-lib-1.21.tar.gz"
    sha256 "be2cd8c4259da63a6cc2c5abf625ebc8ffaab405ec3284c6f7cb6e3431d5f902"
  end
  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.21/hledger-ui-1.21.tar.gz"
    sha256 "14f4f5de87b69b05ca6040cb444cf2e6e8dc1ccae601740cde0c79f00d322dc1"
  end
  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.21/hledger-web-1.21.tar.gz"
    sha256 "e2251687ed0c4dff9fea1767e3c30279df50713bdb9d4c2c1712f0eb19fe7a47"
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
