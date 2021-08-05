class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.22.1/hledger-1.22.1.tar.gz"
  sha256 "112cb975488157418bd96c1b820022ca5705a404c02bc75075533bf6a4eb405e"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/download.html"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aadaf2bc42b31cbedbf7304ff8c558cfef57595b053c82928e5bccbb4f5101fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "6844c80a4704a4768294b5080ab69232304cff9f6c634f824f039cd7a6cdd349"
    sha256 cellar: :any_skip_relocation, catalina:      "594caa1938b436b3181e49c5afd9bea33fd6bacb737f4f47dc00c24857fbf013"
    sha256 cellar: :any_skip_relocation, mojave:        "28357154d7e7edc8e77bd78468aef91b984e33a3946cc185faf07e9a393b63cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f19d35385da9e7ffa407430a8de6d83e809c18f512fc485386fdbc44c742b7c"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.22.1/hledger-lib-1.22.1.tar.gz"
    sha256 "6be4d07e117b15e7534bd3dbbe46c2aac0b21f6c8bd850c10d643815face1f24"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.22.1/hledger-ui-1.22.1.tar.gz"
    sha256 "376e266f9c9b1cc46fbfb75cf94da4b9112310f62bbe952bf37441f0b2ce1b60"
  end

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.22.1/hledger-web-1.22.1.tar.gz"
    sha256 "ed325b267f549498f87041b74133c74c4cce298b6d1dbe2a249f4511c0e09309"
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
