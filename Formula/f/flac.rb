class Flac < Formula
  desc "Free lossless audio codec"
  homepage "https://xiph.org/flac/"
  url "https://ftp.osuosl.org/pub/xiph/releases/flac/flac-1.5.0.tar.xz"
  mirror "https://github.com/xiph/flac/releases/download/1.5.0/flac-1.5.0.tar.xz"
  sha256 "f2c1c76592a82ffff8413ba3c4a1299b6c7ab06c734dee03fd88630485c2b920"
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
    regex(%r{href=(?:["']?|.*?/)flac[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82b19ded7c732c245a9e325c191de60f7d17bb3370afdc98d159852cf3f9dbd5"
    sha256 cellar: :any,                 arm64_sequoia: "c9698bcebe8e99ab84adf49a347cad5a9f122c45b80622a9fe2acbaeab902545"
    sha256 cellar: :any,                 arm64_sonoma:  "2595081ed6509f8f4442067e6b73e1ceccb0e8d68b17e5330ad0c57c9f031b80"
    sha256 cellar: :any,                 arm64_ventura: "52c6aaad150497211c7372401de3017312b4c1587fcf931e4778c17c32ffe07e"
    sha256 cellar: :any,                 sonoma:        "8b3a61d7bedcef1e927057d3d7ef21b1ae69fddfb6a462b98def7f57e306a6a4"
    sha256 cellar: :any,                 ventura:       "f1c784569961db85af848fd5d816d975a987ee986e54d9b48c45effe698755f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e19e26751f4f5c93122102114d7954329b2b1223ada59e8d92afd350a56702b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f5cec1705ffb8d93fb9abbb0b7b0f197d61633d8e0de2a29de825526790006"
  end

  head do
    url "https://gitlab.xiph.org/xiph/flac.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libogg"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--enable-static", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"flac", "--decode", "--force-raw", "--endian=little", "--sign=signed",
                       "--output-name=out.raw", test_fixtures("test.flac")
    system bin/"flac", "--endian=little", "--sign=signed", "--channels=1", "--bps=8",
                       "--sample-rate=8000", "--output-name=out.flac", "out.raw"
  end
end
