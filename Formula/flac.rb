class Flac < Formula
  desc "Free lossless audio codec"
  homepage "https://xiph.org/flac/"
  url "https://downloads.xiph.org/releases/flac/flac-1.4.2.tar.xz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/flac/flac-1.4.2.tar.xz"
  sha256 "e322d58a1f48d23d9dd38f432672865f6f79e73a6f9cc5a5f57fcaa83eb5a8e4"
  license all_of: [
    "BSD-3-Clause",
    "GPL-2.0-or-later",
    "ISC",
    "LGPL-2.0-or-later",
    "LGPL-2.1-or-later",
    :public_domain,
    any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"],
  ]

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/flac/?C=M&O=D"
    regex(/href=.*?flac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4e8f1c6298d840212b30402137e1541750e7769bddf1213a3b4cbf18e960e0bd"
    sha256 cellar: :any,                 arm64_monterey: "fafbe1951be9eebdbd9daa08f3cec73fef2e12e2aa4603dbb45b95c36d47622f"
    sha256 cellar: :any,                 arm64_big_sur:  "91181078081ba0aa0af6738ef4aef7ff9ac53d1860b1a3a9803f3767a5ad8270"
    sha256 cellar: :any,                 ventura:        "83b9a42d2058d67691ec930f01c17ae88e11a68721e751b9ea85c26a6407d09b"
    sha256 cellar: :any,                 monterey:       "7afd024db3ea4b5ee31f91b429570de8858b642d068d1d4367a531f6a3568f6c"
    sha256 cellar: :any,                 big_sur:        "3664f8a725c89f20ebc11ecef657ce848e00322b3750306db980ad23370cab89"
    sha256 cellar: :any,                 catalina:       "9e4c84335e37b5898fd95281731a90e9a105b8ca8000427de0693ec0c1dc78e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "464e13f2c67a7cbd809410f6beb804dcc6da188719b9d39358998a7ca61703c7"
  end

  head do
    url "https://gitlab.xiph.org/xiph/flac.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-static
    ]
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/flac", "--decode", "--force-raw", "--endian=little", "--sign=signed",
                          "--output-name=out.raw", test_fixtures("test.flac")
    system "#{bin}/flac", "--endian=little", "--sign=signed", "--channels=1", "--bps=8",
                          "--sample-rate=8000", "--output-name=out.flac", "out.raw"
  end
end
