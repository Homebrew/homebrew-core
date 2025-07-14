class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/refs/tags/4.14.tar.gz"
  sha256 "954135ee14ad6bd74a78a10db560b534b8f2083ad0615f5c1a2c376fff0301e0"
  license "LGPL-3.0-or-later"
  head "https://github.com/ntop/nDPI.git", branch: "dev"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a9e45fe338e7be68ec51aae2ad6d52cf95cdb90fe6f9e6815345aaaa63048ab"
    sha256 cellar: :any,                 arm64_sonoma:  "3be0627b16ed3db0bf4ed8f225d8bde0813771501c26025c6f0990b19b125d6f"
    sha256 cellar: :any,                 arm64_ventura: "8c2583825dabae16fca840859c371de0a3f074f3301b8bce85eee801087604b2"
    sha256 cellar: :any,                 sonoma:        "8a190f221789ad1f3322ea0a9838591d6f87c3c22060e8a89511699055e5759d"
    sha256 cellar: :any,                 ventura:       "2cade3979a0b532070ed4b17df9a4f69eed173b743385aa4a5232ee6d4c359e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9428a7434774926bfae4b2784133615c7b0c8fce94ce6519d9a4fdc2facaf076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bb8b4eee649008534dbada6d4ad79a7b996223d26944d4d49724e12e866c35e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "json-c"

  uses_from_macos "libpcap"

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
