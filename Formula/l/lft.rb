class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-4.01.tar.gz"
  sha256 "77a2923dbd10b1e3d2b55d8f3c4144795a80f73772d4f41f5e27751d1f3f0c62"
  license "VOSTROM"

  livecheck do
    url :homepage
    regex(/value=.*?lft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "28b467003612952ce8da88579e1a59b71ab2020731393dcf9c15b0ae042468a2"
    sha256 cellar: :any, arm64_tahoe:       "2c40112b2be68d4e3795726c155ce2a6472f633c63d9fc8ce1785b56577325db"
    sha256 cellar: :any, arm64_sequoia:     "7d338e52186416ed983276718c2d6ed0a27a7ca76c025f2544bafa2124e29b79"
    sha256 cellar: :any, arm64_sonoma:      "094ad51fa666ae8fe50de127b5da956649766caeeefd782c897da756df0f614f"
    sha256 cellar: :any, arm64_linux:       "52df348b8b0c2575f2563cb97d22e53a2596c767661afc2aaad4b83821e82f00"
    sha256 cellar: :any, x86_64_linux:      "8779ebca5ff64b3bae3b3f4ba9a55e89906c5b73c77e73d892b1596d58ceb6af"
  end

  depends_on "pkgconf" => :build
  depends_on "c-ares"
  depends_on "ncurses"

  uses_from_macos "libpcap"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1", 1)
    assert_match(/LFT: (insufficient privileges|Failed to activate capture on device)/, output)
  end
end
