class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.2/omniORB-4.2.2.tar.bz2"
  sha256 "ddd909ce31014be2beebf67a5e9fabbf03b5bb0c26b8c53ab64d470d77348ece"

  bottle do
    sha256 "f6b45b799e2266812a33098aeeb1352c009f500ada7e660104dee8c04e6486c1" => :mojave
    sha256 "4d6e50aa2b7e921f95de4423576ad039549cbb10ed4ff034e4ebfac1ff2914fd" => :high_sierra
    sha256 "989ec3dfa6d2cffa72b377822404ff212c9c52b10c6ce1cf7e77ebd5a26a96b4" => :sierra
    sha256 "3c53f669e4832ee9e423bd1c124d3b3e7abd2f061b824fae408f5d553c61060a" => :el_capitan
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
