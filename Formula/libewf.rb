class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  # The main libewf repository is currently "experimental".
  url "https://github.com/libyal/libewf-legacy/releases/download/20140811/libewf-20140811.tar.gz"
  sha256 "b2c3a04ea7f49646518d108df8ea00fc0d2ca670064bb59428d8878ed8aef80d"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "1068de52fbf9dcc6bb65e959db1626da3850cc251c5c9ca4dc87a2f8cd895607" => :big_sur
    sha256 "b2eb1858fa0942fea2edc3db283fe0c09f20ba79fa25ec0b7a4b7547f98a4124" => :arm64_big_sur
    sha256 "a40427480d4e53c8f3886868bb01551a94e3edb14b959465ee4083c9a25f581b" => :catalina
    sha256 "4af14fb4edc94c14ad5400024865c91fb545190abbe5b763e43fb25bd30d33ab" => :mojave
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-libfuse=no
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
