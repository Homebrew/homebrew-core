class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://nfdump.sourceforge.io"
  url "https://github.com/phaag/nfdump/archive/v1.6.19.tar.gz"
  sha256 "1221e3526b67be7d6f6b786d9873e29944b25e37059b6acadc7addf003140fe9"

  bottle do
    cellar :any
    sha256 "5e714bd5193c9b9b2e0d0c76d3fea30c9df0e5e270651723a255227c98931dad" => :catalina
    sha256 "02f8e2a4704fc8ea3e33b518fb13dff8d74abbd7b8cdc6500c18af56362dc599" => :mojave
    sha256 "7e14275c4cc7aebc031a475eb9fbc745c9deb7d3dcc16c40f6c7315dd6fd4968" => :high_sierra
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
