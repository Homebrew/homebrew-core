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
    sha256 cellar: :any,                 arm64_monterey: "d22c0a596ada320cf5c19301e16443098576c1e8b95c5877ec22e5aec7c4fb12"
    sha256 cellar: :any,                 arm64_big_sur:  "ef3f6bb794adea4850253007ba13b5c76786476884e7331c667f358a52220e0c"
    sha256 cellar: :any,                 monterey:       "8a7039889d7d38f0eb28f01c63b3e8b38fe334467e31887dfef3af06b3aaa321"
    sha256 cellar: :any,                 big_sur:        "9ad2505d433534c492ac8255e92e6cb55577d6dc5eb14aeb97eaba3501ce2f0a"
    sha256 cellar: :any,                 catalina:       "58b1701ca8769a32e55f56c820c96a2d402b6dddace75a5acd0b561efdbe2c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "645d0731a2e3a11a7d24e35bbb83a268eb39f4c616556c4b8b3b6c90770c99b6"
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
