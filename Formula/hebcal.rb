class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.16.tar.gz"
  sha256 "78c212f34b4aaf3f683b0c961d9d9f0a42bdd5666dece58f9029e3908c2f1c0f"

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
