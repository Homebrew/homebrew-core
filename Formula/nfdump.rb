class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://nfdump.sourceforge.io"
  url "https://github.com/phaag/nfdump/archive/v1.6.18.tar.gz"
  sha256 "5d6046bf7faa34713b004c6cf8b3d30027c761c5ac22a3195d49388342e8147e"

  bottle do
    cellar :any
    sha256 "dddf3a460d59b020d24243fa355a751625c1a79b45e69f90b68c6ca1a476ffa6" => :mojave
    sha256 "4011e1aa739d163bf04d5df0bff1bb779e89c5a0253332325da99ccf65ea6965" => :high_sierra
    sha256 "7f810fe9a5e90455e8e3e2bf80fc474dd56a752a1f87310a80399d819e8e4d4b" => :sierra
    sha256 "9312372f4ecd45cb576cbe261b6caca79f6baf314421f4c3165e99e1368aa934" => :el_capitan
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
