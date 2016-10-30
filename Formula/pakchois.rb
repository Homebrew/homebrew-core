class Pakchois < Formula
  desc "PKCS #11 wrapper library"
  homepage "http://www.manyfish.co.uk/pakchois/"
  url "http://www.manyfish.co.uk/pakchois/pakchois-0.4.tar.gz"
  sha256 "d73dc5f235fe98e4d1e8c904f40df1cf8af93204769b97dbb7ef7a4b5b958b9a"

  bottle do
    sha256 "84a90b245c59676817d4c9100d64d7747068e0d3557fc5c3218d8a83a98f78fe" => :sierra
    sha256 "b02057a2cc01daa05754c537820b58d7c77b632fc5fdb2a6f6dcec77341fe65b" => :el_capitan
    sha256 "30a06a914f2025d7d23dff48fa8523be455bf925a3282a8c35f56779fd8bd27a" => :yosemite
    sha256 "03d6ab9d51bdebf61b3c415908e222467fd31cefc4811200eee9e407c604f7f5" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
