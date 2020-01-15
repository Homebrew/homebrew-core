class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.3.tar.gz"
  sha256 "7c87d4b80936282e78dc3840c64d3afaf1f0d7a486b29efc43699b9b178a9a25"

  bottle do
    cellar :any
    sha256 "31afc14d75ff131ffad66b27964fca8e2418083643551b3c807a114e0160aaad" => :catalina
    sha256 "eeb5bd2a82f3b341cc2d48041eb1fe8f7d6b1e6c3680c3b379d5410153bff81b" => :mojave
    sha256 "3abc77e861ed4733449cb4999befe2619239bb15d0562b5c288ab7894849ca3e" => :high_sierra
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
