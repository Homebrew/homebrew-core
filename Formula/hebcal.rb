class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.4.tar.gz"
  sha256 "411f8c05f65c88a84d56ec1e28e13b2fe60a34fb17b9d06c52adbcb3af98ed74"

  bottle do
    cellar :any_skip_relocation
    sha256 "24249ae917adfd74ec1c1e67ef870329ebfa1b77c7ad3c3c2e58358b0990074b" => :sierra
    sha256 "2e06bf24383b1ffb0057958a495ad63c56046e86abd8eea9a4efe0a90d762b45" => :el_capitan
    sha256 "24e55910c7c1bbcb075196fca25fdc1a06abd5e16df9df536435e934b138dbb2" => :yosemite
    sha256 "00c5f478340499a3aa2f5dc0855921ed91441d3c255dfd5d0975dc53f320b4db" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
