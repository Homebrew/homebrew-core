class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://nfdump.sourceforge.io"
  url "https://github.com/phaag/nfdump/archive/v1.6.18.tar.gz"
  sha256 "5d6046bf7faa34713b004c6cf8b3d30027c761c5ac22a3195d49388342e8147e"

  bottle do
    cellar :any
    sha256 "29c5921e64710a0843b2ca0584213e45295d977650ef2699e3edfbeeab3ab5d5" => :mojave
    sha256 "b79e24cd33227eb6a36db2288b547b825b1b4b754cbfd73d99484b8bd096b857" => :high_sierra
    sha256 "b6b11acd5aa5bf7273fc1e97f046741da8352662cb2aa548e77c809554208dc5" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-readpcap"
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
