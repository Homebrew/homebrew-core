class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.17.tar.gz"
  sha256 "d354ef3a7c56a00e3a83b56fffd499d64ae57d39df0cf8f7f05917d746a9bf49"

  bottle do
    cellar :any_skip_relocation
    sha256 "88b3552aa73695025b19df5e10a2debc8cfeec869e514ae4900ea15d06cae695" => :mojave
    sha256 "1e8b79908fdfaa02b7799faa44c244eacef01725f632fa287a2c3ffe665c3a0b" => :high_sierra
    sha256 "9d037f49508775a3ebbd42e44e6bb05af4cdf169446b168a2893340994ec618e" => :sierra
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
