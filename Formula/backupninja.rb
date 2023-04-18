class Backupninja < Formula
  desc "Backup automation tool"
  homepage "https://0xacab.org/riseuplabs/backupninja"
  url "https://sourcearchive.raspbian.org/main/b/backupninja/backupninja_1.2.1.orig.tar.gz"
  mirror "https://debian.ethz.ch/ubuntu/ubuntu/pool/universe/b/backupninja/backupninja_1.2.1.orig.tar.gz"
  sha256 "833277d36993ddf684b164b581a504b38bbcff16221e416428c90aaf63ed85d4"
  license "GPL-2.0"

  livecheck do
    url "https://sourcearchive.raspbian.org/main/b/backupninja/"
    regex(/href=.*?backupninja[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8f559e4cb9deca4861b7beff6083a5da8d70597d99b4ec6d2c447e57d5331c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8f559e4cb9deca4861b7beff6083a5da8d70597d99b4ec6d2c447e57d5331c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8f559e4cb9deca4861b7beff6083a5da8d70597d99b4ec6d2c447e57d5331c6"
    sha256 cellar: :any_skip_relocation, ventura:        "3e0f3c562e13469570fa3852a72b05745f4ebc4154e306fdf152d33d3b79c0a5"
    sha256 cellar: :any_skip_relocation, monterey:       "3e0f3c562e13469570fa3852a72b05745f4ebc4154e306fdf152d33d3b79c0a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e0f3c562e13469570fa3852a72b05745f4ebc4154e306fdf152d33d3b79c0a5"
    sha256 cellar: :any_skip_relocation, catalina:       "3e0f3c562e13469570fa3852a72b05745f4ebc4154e306fdf152d33d3b79c0a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8f559e4cb9deca4861b7beff6083a5da8d70597d99b4ec6d2c447e57d5331c6"
  end

  depends_on "bash"
  depends_on "dialog"
  depends_on "gawk"

  skip_clean "etc/backup.d"

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "BASH=#{Formula["bash"].opt_bin}/bash"
    system "make", "install", "SED=sed"
  end

  def post_install
    (var/"log").mkpath
  end

  test do
    assert_match "root", shell_output("#{sbin}/backupninja -h", 3)
  end
end
