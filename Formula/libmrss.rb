class Libmrss < Formula
  desc "C library for RSS files or streams"
  homepage "https://www.autistici.org/bakunin/libmrss/"
  url "https://www.autistici.org/bakunin/libmrss/libmrss-0.19.2.tar.gz"
  sha256 "071416adcae5c1a9317a4a313f2deb34667e3cc2be4487fb3076528ce45b210b"

  bottle do
    cellar :any
    rebuild 2
    sha256 "03a62a0d10dd05156876128388b1081c329a00f38d71d6e8b52bff20b3d40fbe" => :catalina
    sha256 "66000637d850285b2fd66f2fc00ae5a3096690ec84b8280037c39bff3246612c" => :mojave
    sha256 "234ec50cc4eabdd5433abb2d27f1e359c468db4fda10a36eb2c9278034a4e000" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libnxml"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
