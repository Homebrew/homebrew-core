class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.6.tar.gz"
  sha256 "9cf7b653951aeafa951eefe68bf6ae7d4b4652ede324209cb37b720de90ca638"

  bottle do
    cellar :any
    sha256 "337dfe5746991f1a87fc48fca513913fed424ab5fa9315a06d0cdc87861b324f" => :catalina
    sha256 "bc1a6449cd2ee6bef18dfdf345ae789e3c55c61d61cc23f021ddebaedf193b66" => :mojave
    sha256 "df05d7fdce285b10df1f62c9f1827e63c2aa49e4d170ce5fe12ae43ec10673fb" => :high_sierra
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
