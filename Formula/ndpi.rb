class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/4.0.tar.gz"
  sha256 "99e0aba6396fd633c3840f30e4942f6591a08066d037f560b65ba64e7310f4d6"
  license "LGPL-3.0-or-later"
  head "https://github.com/ntop/nDPI.git", branch: "dev"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a64affa1ea8a62120fbd60ce78cb9ed2d057963183e7ac50a734ae966480a416"
    sha256 cellar: :any, arm64_big_sur:  "715cd2c118ed42c2200c324ca4c929f86c37466fb08ff4b6b958ba1f7fe11658"
    sha256 cellar: :any, monterey:       "f37761fc6e35ce2b2104af482f3034bbe26945b2d314aa8ecef95cdcd7f7b939"
    sha256 cellar: :any, big_sur:        "eb9f83ab515f4d710dc245aac5cedb809dd5a5fd6192b4d075bdfbfb28d81c70"
    sha256 cellar: :any, catalina:       "8366ae839e98cf9aa0b6358ce0f110ffc4138fb9dcc4ba97bf9cf1c5872a61ff"
    sha256 cellar: :any, mojave:         "438bc0a2c96515c8a6318b38d9c7b52dcf49111fc8721e7ae59f0e65249729fa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
