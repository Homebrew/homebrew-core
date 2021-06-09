class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://www.onioncat.org"
  url "https://www.cypherpunk.at/ocat/download/Source/0.3/onioncat-0.3.9.tar.gz"
  sha256 "c9f2f62fe835f9055c4b409a93f514f9dffdd1fcaeb9d461854731303b528e90"
  license "GPL-3.0"

  livecheck do
    url "https://www.cypherpunk.at/ocat/download/Source/current/"
    regex(/href=.*?onioncat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8bca5a514c5cb61ae1ff7f3988b4ba94a4d31a423fa888392d8f7f87af2a590"
    sha256 cellar: :any_skip_relocation, big_sur:       "7df945c9dee96b07e1133d8bee08f937cdb53ceca5e4efeaa1e0f2093018c405"
    sha256 cellar: :any_skip_relocation, catalina:      "18bca9a7fa0830c5efb83c8914923202b6a1ed0abadf5cc4755c04c54978e3eb"
    sha256 cellar: :any_skip_relocation, mojave:        "102814e9feb8bccb65537f9fd156e3b718466dfafdf7df6e513ab5b5e3560ff3"
    sha256 cellar: :any_skip_relocation, high_sierra:   "cef6fe952042a8b9d838a8369f96c9ab74d83eb271ccdf4829e0b23ba89dee58"
  end

  depends_on "tor"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    rm_f "#{bin}/gcat" # just a symlink that does the same as ocat -I
  end

  test do
    system "#{bin}/ocat", "-i", "fncuwbiisyh6ak3i.onion" # convert keybase's address to IPv6 address format
  end
end
