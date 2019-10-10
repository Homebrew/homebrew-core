class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.6.2.tar.gz"
  sha256 "6df6876f3f7b1dd8afeb3d5f88bfb9269f52d5d796258c4414bdd91aa2eac0a6"
  revision 1
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "6551a83f9631ab9879cf5be28c449f3b1fd3f70d129eed897b03a2490dbb51ca" => :catalina
    sha256 "fb99bac2c1af58f7cd09658c38d5acf01c3c429def359f47e4648d6ae46999f6" => :mojave
    sha256 "6a1e53117809e967f86a1d88857d1cd8993485b7dfb9a02621c02c6bead4784d" => :high_sierra
    sha256 "e64b23d56bd8fe79b1781de62a9cbb1bd18216040554bc13b73e605a9288bcb2" => :sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "geoip"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
