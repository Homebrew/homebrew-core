class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "https://pmt.sourceforge.io/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.13/pngcrush-1.8.13-nolib.tar.xz"
  sha256 "3b4eac8c5c69fe0894ad63534acedf6375b420f7038f7fc003346dd352618350"
  # The license is similar to "Zlib" license with clauses phrased like
  # the "Libpng" license section for libpng version 0.5 through 0.88.
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/pngcrush[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "50d8436ee484470b88c0cdf9a26a3ad4944eeaa2361b367ec4fd8a2672a09dec"
    sha256 cellar: :any,                 arm64_sequoia:  "75989b83be1fbc178d98f4f95701ad605c5374b1f46bde052c9b00da7cd30451"
    sha256 cellar: :any,                 arm64_sonoma:   "dc9ce31ceb46f11395e278373105809e820a7f5c7f5f5ccb5f13ea524d11778a"
    sha256 cellar: :any,                 arm64_ventura:  "dd2cab183f751d9587c1a6d7fbb9413354efbb4c608439969a301cc1d156f7ba"
    sha256 cellar: :any,                 arm64_monterey: "748b50c94bac90c737a32e6292b60c2d122cac6bd41152dedb0250f96b577520"
    sha256 cellar: :any,                 sonoma:         "1b0c5196ebfe0b7a78313a4ab95345d0309fcf0904322e7a4efa57f85ebe8270"
    sha256 cellar: :any,                 ventura:        "5db90e14f1775d85c6dbb33ab0d0c6d96232f4da05489b845f0f6d3c4ffa579c"
    sha256 cellar: :any,                 monterey:       "6d59cef2837c1e448fd0501291b94c363229b6af303f2bf2534e17d5e46cfa21"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b85fdd4432e188ce43213bcb8f023303cb8b3e196424c793af66f15ffe1457d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a27f56827740191ffc0b61fc71746628d09270bf82d42bbbe009ebeae299f8a2"
  end

  depends_on "libpng"

  uses_from_macos "zlib"

  # Use Debian's patch to fix build with `libpng`.
  # Issue ref: https://sourceforge.net/p/pmt/bugs/82/
  patch do
    url "https://sources.debian.org/data/main/p/pngcrush/1.8.13-1/debian/patches/ignore_PNG_IGNORE_ADLER32.patch"
    sha256 "d1794d1ffef25a1c974caa219d7e33c0aa94f98c572170ec12285298d0216c29"
  end

  def install
    zlib = OS.mac? ? "#{MacOS.sdk_path_if_needed}/usr" : Formula["zlib"].opt_prefix
    args = %W[
      CC=#{ENV.cc}
      LD=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      PNGINC=#{Formula["libpng"].opt_include}
      PNGLIB=#{Formula["libpng"].opt_lib}
      ZINC=#{zlib}/include
      ZLIB=#{zlib}/lib
    ]
    system "make", *args
    bin.install "pngcrush"
  end

  test do
    system bin/"pngcrush", test_fixtures("test.png"), File::NULL
  end
end
