class Bwctl < Formula
  desc "Command-line tool and daemon for network measuring tools"
  homepage "https://software.internet2.edu/bwctl/"
  url "https://software.internet2.edu/sources/bwctl/bwctl-1.5.4.tar.gz"
  sha256 "e6dca6ca30c8ef4d68e6b34b011a9ff7eff3aba4a84efc19d96e3675182e40ef"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "125c3592d5a34d3913dde26356ee894136716f6b224ab1d8bc14ab487fbd2633" => :catalina
    sha256 "b4e91dbfca063d51a0280dffde519e9d4e5d66d0e0a301936dbbe86239e295a3" => :mojave
    sha256 "2d326aaaa5c9031fd668569cbd68627d84884389b4883282d82259af152b12c3" => :high_sierra
  end

  # https://software.internet2.edu/bwctl/
  # The use of BWCTL became deprecated with the release of pScheduler in perfSONAR 4.0 in April, 2017.
  deprecate! date: "2017-04-01", because: :deprecated_upstream

  depends_on "i2util" => :build

  def install
    # configure mis-sets CFLAGS for I2util
    # https://lists.internet2.edu/sympa/arc/perfsonar-user/2015-04/msg00016.html
    # https://github.com/Homebrew/homebrew/pull/38212
    inreplace "configure", 'CFLAGS="-I$I2util_dir/include $CFLAGS"', 'CFLAGS="-I$with_I2util/include $CFLAGS"'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-I2util=#{Formula["i2util"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bwctl", "-V"
  end
end
