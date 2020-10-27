class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://www.onioncat.org"
  url "https://www.cypherpunk.at/ocat/download/Source/0.3/onioncat-0.3.8.tar.gz"
  sha256 "9564d10c64161408a573256ba8aece9296499a753cbdae6bfbc3544e72a1d63b"
  license "GPL-3.0"

  livecheck do
    url "https://www.cypherpunk.at/ocat/download/Source/current/"
    regex(/href=.*?onioncat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "18bca9a7fa0830c5efb83c8914923202b6a1ed0abadf5cc4755c04c54978e3eb" => :catalina
    sha256 "102814e9feb8bccb65537f9fd156e3b718466dfafdf7df6e513ab5b5e3560ff3" => :mojave
    sha256 "cef6fe952042a8b9d838a8369f96c9ab74d83eb271ccdf4829e0b23ba89dee58" => :high_sierra
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
