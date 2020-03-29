class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.4.tar.gz"
  sha256 "87a168d0198d76793149bb0fae18679aa602352ec649b53dd96f048ff01264ee"

  bottle do
    cellar :any
    sha256 "514a5e3cac0fe5a8d3c79ec37feec35dddc8512860c0a59f3a1c380be0b7b956" => :catalina
    sha256 "c6fbb6c41c3e461b49ac4a607b403bdb8dbff8430bf4bfa53b20d283ebacdeba" => :mojave
    sha256 "21fddaeb153146c98a8072611945535cab4f10dbbce70800ceea7031edfae554" => :high_sierra
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
