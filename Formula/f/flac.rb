class Flac < Formula
  desc "Free lossless audio codec"
  homepage "https://xiph.org/flac/"
  url "https://downloads.xiph.org/releases/flac/flac-1.4.3.tar.xz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/flac/flac-1.4.3.tar.xz"
  sha256 "6c58e69cd22348f441b861092b825e591d0b822e106de6eb0ee4d05d27205b70"
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
    sha256 cellar: :any,                 arm64_sequoia:  "aaed493bc3a3d841318f952a119cb5cd2646f9a9950f20e9458717969f6c662f"
    sha256 cellar: :any,                 arm64_sonoma:   "ce19f4c9e89fb7b89c5ea1c070bb6cdb7deedf800a6843bd042ceb902b43ed03"
    sha256 cellar: :any,                 arm64_ventura:  "3962fce4abb2716cd21a9b9ebeda4f2e5c4bea08c32ea3cc0316f369da054019"
    sha256 cellar: :any,                 arm64_monterey: "187cfc571ab437b847cb2da754706a271be30727637cde5b60fa982568ebcf91"
    sha256 cellar: :any,                 arm64_big_sur:  "08f362bb71849942d8dcbf6603172b06b0abf2188f34fcce45bd6a525cd050f0"
    sha256 cellar: :any,                 sonoma:         "a38b2616d47bd13a0002124b05a13e121bbb8a6b4fb566d5e20d58d88d4eecee"
    sha256 cellar: :any,                 ventura:        "643038462da4e717c7d7dc5c3925e1544db2d0448f816954281fba3cb7ee9c24"
    sha256 cellar: :any,                 monterey:       "6d3f6605110bddf5f11eb290622b1043f1309229bf49d0cb66e485f73e9c1074"
    sha256 cellar: :any,                 big_sur:        "6fb65cf0ac1991a168c0be6116bb04ba56393f5af3947ab011b3eba17744c39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45cbf41355347a7d84d726195785238b5fff48155bdfa95db12eeb401e18e19f"
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
    system bin/"flac", "--decode", "--force-raw", "--endian=little", "--sign=signed",
                          "--output-name=out.raw", test_fixtures("test.flac")
    system bin/"flac", "--endian=little", "--sign=signed", "--channels=1", "--bps=8",
                          "--sample-rate=8000", "--output-name=out.flac", "out.raw"
  end
end
