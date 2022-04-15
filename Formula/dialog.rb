class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20220414.tgz"
  sha256 "493781718642cdd58bdba1cdf2a26776ca855908710d813bd2e93810dc49ece2"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6416f5ced5a9df460e0749bd8ddc70761e8b1277fbe0d50461e21d7dc260b65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5da2362b2d79f7103aa14bbbe94ab1997828acfb3632f52b53b326bf22ce5a02"
    sha256 cellar: :any_skip_relocation, monterey:       "924f9c2a183dbe4a5569920439139880a4f8b1885bc5e8ba2432407f1e2eec02"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3cbb241e0a0e7ce3f00a7a62787eefbeeff1093b1250c8276db20c5a91924ab"
    sha256 cellar: :any_skip_relocation, catalina:       "c3b26717d508ffad00c2a389c159af92659322cbabb42313e9078259cc79dfae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69cc9da2efda63e3df5aea8adaaa64867d459cb2164556e1d7f5430f190796ee"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
