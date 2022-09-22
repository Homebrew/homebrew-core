class Flac < Formula
  desc "Free lossless audio codec"
  homepage "https://xiph.org/flac/"
  url "https://downloads.xiph.org/releases/flac/flac-1.4.1.tar.xz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/flac/flac-1.4.1.tar.xz"
  sha256 "91303c3e5dfde52c3e94e75976c0ab3ee14ced278ab8f60033a3a12db9209ae6"
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
    sha256 cellar: :any,                 arm64_monterey: "b28eb662fa249a1c7a52c2ddcbfcc0a8234ab6af1c4106a802d72c831eb4b2f4"
    sha256 cellar: :any,                 arm64_big_sur:  "cd5f7c81c96292f443d87c300fb384c79cd482cc1d9634a5127b08e7ba9d7044"
    sha256 cellar: :any,                 monterey:       "01e8e78f2b677a6baa484baff6e58bdbf5c848ee2f9a1356461678a7301478e7"
    sha256 cellar: :any,                 big_sur:        "4c8f98283d1643179dd1ab5dc0a25a1634786bda6dc9156277b9e2c78b097553"
    sha256 cellar: :any,                 catalina:       "aecc4b3af655c6c55fa644eded750fcaaceaf5a829bac2145f99d2aa3b871f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc67c5532ae6c74b1799498f8a1bdb53fe0553f04c4e20069e73e3bf6ca2394f"
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
