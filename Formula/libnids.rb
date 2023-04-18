class Libnids < Formula
  desc "Implements E-component of network intrusion detection system"
  homepage "https://libnids.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libnids/libnids/1.24/libnids-1.24.tar.gz"
  sha256 "314b4793e0902fbf1fdb7fb659af37a3c1306ed1aad5d1c84de6c931b351d359"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a9b786affb4887f607fabbe0df202bdf0d1601ae3210afbf6337577a23ca49ef"
    sha256 cellar: :any,                 arm64_monterey: "085e5576236a751d84a975412ef34f206f2eb0c639c826dde4a7298cea4f00d3"
    sha256 cellar: :any,                 arm64_big_sur:  "6c7f242b8c5564eebc95837bf61f5760b88e2e543772357d43132921f20f858d"
    sha256 cellar: :any,                 ventura:        "38b6e4dea05881c126f5abfaa13e8f4c8e5435cf6e51a135ce1c3fd10c120227"
    sha256 cellar: :any,                 monterey:       "bb00ea7f83f736bb27b63da94cd2fe4ad077c5aab62a357a4e996fa2cc98e123"
    sha256 cellar: :any,                 big_sur:        "0235b5bccac955c60852984ed13fa3213e3ccad9c0fe36ae522b5ac53f1f2a42"
    sha256 cellar: :any,                 catalina:       "0cd6c420a38ea61eb8abe96b6b2f754bddf1ca5583b3dbccfb1b268990426764"
    sha256 cellar: :any,                 mojave:         "175d04b2db4bc65923eed696272339f4533ea8277ec64f01ba6a2b9a6019c8d6"
    sha256 cellar: :any,                 high_sierra:    "e9e968ec057ae597b39c45ff1e804fde87f265c6783e62cb70e009ecc4aafd05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53191548aacc1a482ec1bec888da8809da4c17b7b88e631b7c725acce36456e9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libnet"

  uses_from_macos "libpcap"

  # Patch fixes -soname and .so shared library issues. Unreported.
  patch do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9dc80757ba32bf5d818d70fc26bb24b6f/libnids/1.24.patch"
      sha256 "d9339c16f89915a02025f10f26aab5bb77c2af85926d2d9ff52e9c7bf2092215"
    end
  end

  def install
    # autoreconf the old 2005 era code for sanity.
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "--enable-shared"
    system "make", "install"
  end
end
