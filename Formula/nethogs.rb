class Nethogs < Formula
  desc "Net top tool grouping bandwidth per process"
  homepage "https://raboof.github.io/nethogs/"
  url "https://github.com/raboof/nethogs/archive/v0.8.6.tar.gz"
  sha256 "317c1d5235d4be677e494e931c41d063a783ac0ac51e35e345e621d261c2e5a0"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32426b99a5bcf2f44d7d43bd12c756d5036fb1e641d03ed9d60cd5b60cb5555f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3f484a2c5c94bc70fd5c937e3c0190f10d7103aa3fc70095674d32a868defb8"
    sha256 cellar: :any_skip_relocation, monterey:       "bb43af5d9851799f33e2c1463babb68b1bf8f376259d08c710ba3f39906e704e"
    sha256 cellar: :any_skip_relocation, big_sur:        "62bbe8c3e7b74653afa73d4be4ea0218b414a22fd7f2cd8b2fac3b86a58833df"
    sha256 cellar: :any_skip_relocation, catalina:       "6f6124fdf95847d5a49d15733e1bebb0b7060995f7ad672863fcd89bb985ef1d"
    sha256 cellar: :any_skip_relocation, mojave:         "e61f5ad80657ad381414c992a391d454689f6845965387c7b803f115b5fd72b4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f994c61fe07025f7c18de9a15be44c3de107e12c19cde6e3cd53a892cc61b7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50692e5123b3e36e79261ec859432dce8220e713f6296f3c664026cc82795fc5"
  end

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Using -V because other nethogs commands need to be run as root
    system sbin/"nethogs", "-V"
  end
end
