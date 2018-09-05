class Pakchois < Formula
  desc "PKCS #11 wrapper library"
  homepage "https://web.archive.org/web/www.manyfish.co.uk/pakchois/"
  url "https://web.archive.org/web/20161220165909/www.manyfish.co.uk/pakchois/pakchois-0.4.tar.gz"
  sha256 "d73dc5f235fe98e4d1e8c904f40df1cf8af93204769b97dbb7ef7a4b5b958b9a"

  bottle do
    sha256 "40909ddce4f17e53dd3b6bd68b61c45cfd824ccc486fe2bf0e76be5f55d5681d" => :mojave
    sha256 "ee7978dad7998e747e468f1b9afaa692304efb2ca857d4c0903945f030841fb7" => :high_sierra
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
