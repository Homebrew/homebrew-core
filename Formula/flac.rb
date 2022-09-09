class Flac < Formula
  desc "Free lossless audio codec"
  homepage "https://xiph.org/flac/"
  url "https://downloads.xiph.org/releases/flac/flac-1.4.0.tar.xz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/flac/flac-1.4.0.tar.xz"
  sha256 "af41c0733c93c237c3e52f64dd87e3b0d9af38259f1c7d11e8cbf583c48c2506"
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
    sha256 cellar: :any,                 arm64_monterey: "ca0f491b3a3c353e7562d0e8f25a1b54d07c760d4164251ab328239d276ba600"
    sha256 cellar: :any,                 arm64_big_sur:  "7e13abd55a15c99201005e8f311c0015225f59c82f7408e314d3cbfb5f98f06e"
    sha256 cellar: :any,                 monterey:       "cf8ac3c3150544be3b809a549c7cf7bb71344904e1b4d4c9c9970c38aa7b2072"
    sha256 cellar: :any,                 big_sur:        "2edc8dddafb0731d45237cdcb5036ff60988575fa9171691b7dc9aa8215430e4"
    sha256 cellar: :any,                 catalina:       "48463384c101270b29fb1b436443ee8b67dec9af0830c58adce44225142de8a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dab52777c3c995c3d7b93b5a86d2ca6ad1e9f5be97f993132ace30c50cc3af5"
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
