class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.24/hledger-1.24.tar.gz"
  sha256 "c01a0111c3d3cf51f6facd07fbc5b7d36d045a247f18a02b272144120b065ca5"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/download.html"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7751dd2ed9c724738c798dcd4b20bb7988b923e445ef9e9cb16254872775e60a"
    sha256 cellar: :any_skip_relocation, big_sur:       "21077fbcdcbd900ae5146982658d5c1a08ab83ec42325601cab600458d9bd3d8"
    sha256 cellar: :any_skip_relocation, catalina:      "d4a47b24b534c9430913e128cb62b714b62ae8e3fcf425f9cdabeb1e8b4156ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff8fe085d89f6a73a46cd103451a6bfd32c4104ec806404f45ddd3f718f02c3"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.24/hledger-lib-1.24.tar.gz"
    sha256 "9496ed498c06f0eaf551092e5b533290be0fec48db2a053eaa1ccecab66458be"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.24/hledger-ui-1.24.tar.gz"
    sha256 "2c65762ff976518603598f2624fe0789696b901172bbfafd496368e4ce311628"
  end

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.24/hledger-web-1.24.tar.gz"
    sha256 "71e56feaa76143f0dfb13815ba0021b86fe152f7926a336faaa0113dc336f276"
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
