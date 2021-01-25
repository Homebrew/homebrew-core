class Pacman4console < Formula
  desc "Pacman for console"
  homepage "https://sites.google.com/site/doctormike/pacman.html"
  url "https://sites.google.com/site/doctormike/pacman-1.3.tar.gz"
  sha256 "9a5c4a96395ce4a3b26a9896343a2cdf488182da1b96374a13bf5d811679eb90"
  license "GPL-2.0"

  bottle do
    sha256 "299dbf7613b12c270c398dc9aa3255eb5f987331c4a1ace1f1ef811bb6070514" => :big_sur
    sha256 "b9f6328a3b683121a3ef8cfb48d6db7c6a25ba07f73a006430298ca7fc5bf658" => :arm64_big_sur
    sha256 "6fdf8244cec5bb8ab55eefb1be9dc8f034c31ddbb3b39b21cd83f535e4e1a500" => :catalina
    sha256 "ea3959a6317d2a3cfdb317622dafa97be5763b13509e06c7c0199eda4e349d33" => :mojave
    sha256 "8b75a7198742924ea2e7545c4ed98dac3d28dcdc9469ff097666b0249a8ff2f7" => :high_sierra
    sha256 "496938f00189695a57af2ef862b97c237d8bcf4c422b8e1d24c309cb8e83d0cd" => :sierra
    sha256 "713a6a48016edcd709c27f84c5e743a0f95f95a3d01da7303a2562b2f3dee68d" => :el_capitan
    sha256 "0177bce0045d06947a44cd810e3af8abdf2853981fe8564782a83474fc45f727" => :yosemite
  end

  def install
    system "make", "prefix=#{prefix}", "datarootdir=#{pkgshare}"
    bin.install ["pacman", "pacmanedit"]
    (pkgshare+"pacman").install "Levels"
  end
end
