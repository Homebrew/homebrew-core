class Libnids < Formula
  desc "Implements E-component of network intrusion detection system"
  homepage "https://libnids.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libnids/libnids/1.24/libnids-1.24.tar.gz"
  sha256 "314b4793e0902fbf1fdb7fb659af37a3c1306ed1aad5d1c84de6c931b351d359"
  revision 2

  bottle do
    cellar :any
    sha256 "0cd6c420a38ea61eb8abe96b6b2f754bddf1ca5583b3dbccfb1b268990426764" => :catalina
    sha256 "175d04b2db4bc65923eed696272339f4533ea8277ec64f01ba6a2b9a6019c8d6" => :mojave
    sha256 "e9e968ec057ae597b39c45ff1e804fde87f265c6783e62cb70e009ecc4aafd05" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libnet"

  # Patch fixes -soname and .so shared library issues. Unreported.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9dc80757ba32bf5d818d70fc26bb24b6f/libnids/1.24.patch"
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
