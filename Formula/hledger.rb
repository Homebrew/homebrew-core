class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.24.1/hledger-1.24.1.tar.gz"
  sha256 "5e7a578c36e9b120bcc80082e9e0444e12e480ef06478431ea56089efb89c907"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
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
    url "https://hackage.haskell.org/package/hledger-lib-1.24.1/hledger-lib-1.24.1.tar.gz"
    sha256 "916200b33120282e7c68bc7c8dbeb797d3bb73509870bd6e42bb5ab35128988e"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.24.1/hledger-ui-1.24.1.tar.gz"
    sha256 "58085c50712fe799d54f4a4d52a5c6b33d840cd134c35fd7ce0373d491dcdda9"
  end

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.24.1/hledger-web-1.24.1.tar.gz"
    sha256 "483ba51bad9ef74ecebb2147a632915b1dc53148261f30e8f8b1c2b07a29bada"
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
