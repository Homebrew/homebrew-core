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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f90771ab2a7452000b57fa958fe4b22f3ee9623145449a4021a64a7160ff3e5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40f981f1c2d95f993249d1716b3e6193dfad9e3731e8d7f69ede25046a0fd960"
    sha256 cellar: :any_skip_relocation, monterey:       "2f0edf6c284d728ad4146005d49966ef7b90c347fffa2585358b3d96a724ce2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9053dd0ef8e185c7d328e3ea488106c567bf4fcff6b1b864f63ce2a0b6a882f0"
    sha256 cellar: :any_skip_relocation, catalina:       "2cc9de36de4f8fb6bf5ef7776b7e8de219444123df698ac4a9cbfc7a87f0d4e6"
    sha256 cellar: :any_skip_relocation, mojave:         "ea6c02f40094f48e34c8a4bd03d66761ddf6262745683006d58d26a27e5f5a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6032e98bbce7b3c2182c06ff794abcdcfd4ac8743d61ca367d346120c2130680"
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
