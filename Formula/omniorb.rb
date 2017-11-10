class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.2/omniORB-4.2.2.tar.bz2"
  sha256 "ddd909ce31014be2beebf67a5e9fabbf03b5bb0c26b8c53ab64d470d77348ece"

  bottle do
    sha256 "df5d22d984eadfbf95c63ba8fc66575cc7595658f6f981a564716d62280e7396" => :high_sierra
    sha256 "f4a91e6e3f3b785604c06c9717a98355f22538e1e95bb0fe0b8dfa68070b4925" => :sierra
    sha256 "f433740ab82239c1e634f77c90a7657d540df7bcecb8666461b38584e25f76db" => :el_capitan
    sha256 "a7ec7b6c556d1fa1fa447e07cfddbe30e0c6a0936637c554c43d5162baf8e3af" => :yosemite
    sha256 "6fdf2acaf82b96459db16f272b97ac8a7ac4088227a2dcfb69331d3b7f672568" => :mavericks
  end

  depends_on "pkg-config" => :build

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.2/omniORBpy-4.2.2.tar.bz2"
    sha256 "f3686e5f85b7c7fec83a1ec97dc6874d336e24830c0e68f1e1ecbd798fa1696a"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
  end
end
