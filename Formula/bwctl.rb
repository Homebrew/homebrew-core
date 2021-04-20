class Bwctl < Formula
  desc "Command-line tool and daemon for network measuring tools"
  homepage "https://github.com/perfsonar/bwctl"
  url "https://github.com/perfsonar/bwctl/archive/refs/tags/1.6.7.tar.gz"
  sha256 "d840c4a97d36b1eb431bcbab8047f1dd975029bed1e4cb13e3c33d69204abb5a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2e2238ee21630377e6ebc42ed442f21fd0ab3a6cffab36bb15c0a522b293c35"
    sha256 cellar: :any_skip_relocation, big_sur:       "57c336c55eb4ec62d4b2f6da7c5f44e47bd6ed20bbb63605639e3725a9cb4284"
    sha256 cellar: :any_skip_relocation, catalina:      "125c3592d5a34d3913dde26356ee894136716f6b224ab1d8bc14ab487fbd2633"
    sha256 cellar: :any_skip_relocation, mojave:        "b4e91dbfca063d51a0280dffde519e9d4e5d66d0e0a301936dbbe86239e295a3"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2d326aaaa5c9031fd668569cbd68627d84884389b4883282d82259af152b12c3"
  end

  # https://github.com/perfsonar/bwctl
  # The use of BWCTL became deprecated with the release of pScheduler in perfSONAR 4.0 in April, 2017.
  deprecate! date: "2017-04-01", because: :deprecated_upstream

  depends_on "i2util" => :build

  def install
    # configure mis-sets CFLAGS for I2util
    # https://github.com/perfsonar/i2util
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
