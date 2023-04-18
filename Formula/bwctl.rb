class Bwctl < Formula
  desc "Command-line tool and daemon for network measuring tools"
  homepage "https://software.internet2.edu/bwctl/"
  url "https://software.internet2.edu/sources/bwctl/bwctl-1.5.4.tar.gz"
  sha256 "e6dca6ca30c8ef4d68e6b34b011a9ff7eff3aba4a84efc19d96e3675182e40ef"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "313b7d87f7a08e81d8c3522c3d4f5e5281ff21767b290b2bfe51ae7538e32011"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2e2238ee21630377e6ebc42ed442f21fd0ab3a6cffab36bb15c0a522b293c35"
    sha256 cellar: :any_skip_relocation, monterey:       "b25e1e3d6c070f43f85eda5263ba25d051a8e491235cf724d166d7d5ca3f2eb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "57c336c55eb4ec62d4b2f6da7c5f44e47bd6ed20bbb63605639e3725a9cb4284"
    sha256 cellar: :any_skip_relocation, catalina:       "125c3592d5a34d3913dde26356ee894136716f6b224ab1d8bc14ab487fbd2633"
    sha256 cellar: :any_skip_relocation, mojave:         "b4e91dbfca063d51a0280dffde519e9d4e5d66d0e0a301936dbbe86239e295a3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2d326aaaa5c9031fd668569cbd68627d84884389b4883282d82259af152b12c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1baa7c580ca0122ac344d60c8884083c0b87ed3efb0b82b6e4af10c5c08257e"
  end

  # https://software.internet2.edu/bwctl/
  # The use of BWCTL became deprecated with the release of pScheduler in perfSONAR 4.0 in April, 2017.
  disable! date: "2022-07-31", because: :deprecated_upstream

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
