class Libnids < Formula
  desc "Implements E-component of network intrusion detection system"
  homepage "https://libnids.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libnids/libnids/1.24/libnids-1.24.tar.gz"
  sha256 "314b4793e0902fbf1fdb7fb659af37a3c1306ed1aad5d1c84de6c931b351d359"
  revision 1

  bottle do
    cellar :any
    sha256 "3439fed4035b6ed2eb7cc491514ba2ac108fdf57fec9fb18e14e0efb1b375913" => :catalina
    sha256 "d42b4d49f5b6e4b465cbed83337adcc218d32c99c754b89b249d8f2c675a02f9" => :mojave
    sha256 "35f886a96ce255259d1cef139939cf760f3fc3b3b35664f9a59e9a8bdf27f072" => :high_sierra
    sha256 "b0ab2ca7fe6339f9ce06b6916e6205792a62b123e3887f7e372a9ed3a6ce85ed" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libnet"

  # Patch fixes -soname and .so shared library issues. Unreported.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/libnids/1.24.patch"
    sha256 "d9339c16f89915a02025f10f26aab5bb77c2af85926d2d9ff52e9c7bf2092215"
  end

  def install
    # autoreconf the old 2005 era code for sanity.
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "--enable-shared"
    system "make", "install"
  end
end
