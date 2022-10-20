class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.17.2.tar.gz"
  sha256 "12a1b91b506f0f8cc4ecede0686c894a798ae9c9130717f875d6969df7274793"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a734b45954dab46148247b64dc0b41aaa20d11048f001102e8f7786770b35cd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a853f9de02a1419b801046bd561c3f3b09912b1d7df1b1119e4b22dd5c29da37"
    sha256 cellar: :any_skip_relocation, monterey:       "26c136026b22e8c13ae136d984af578ef2d32ae189216da6761b1435428cb4a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "09f59209f7737020ccfae79fb88a91531ebf01d6f2fd7f7dfb1784a1023af44e"
    sha256 cellar: :any_skip_relocation, catalina:       "02a284dfc9cc69a4257e3ff8db991e0ae91bee8ef8fa10c164cb730ab1567c86"
    sha256                               x86_64_linux:   "5c91761cb4cb852674e949cd0a2253f7d8602528d2df70afb71cc7f99968a6f6"
  end

  depends_on xcode: ["12.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/mint", "help"
    # Test showing list of installed tools
    system "#{bin}/mint", "list"
  end
end
